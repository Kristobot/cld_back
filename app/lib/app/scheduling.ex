defmodule App.Scheduling do
  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Scheduling.{Calendar, Appointment}

  def create_calendar(attrs \\ %{}) do
    %Calendar{}
    |> Calendar.changeset(attrs)
    |> Repo.insert()
  end

  def update_calendar(%Calendar{} = calendar, attrs) do
    calendar
    |> Calendar.update_changeset(attrs)
    |> Repo.update()
  end

  def get_calendar(id) do
    case Repo.get(Calendar, id) do
      nil -> {:error, :not_found}
      calendar -> {:ok, calendar}
    end
  end

  def get_calendar_by_dentist(dentist_id) do
    case Repo.get_by(Calendar, dentist_id: dentist_id) do
      nil -> {:error, :not_found}
      calendar -> {:ok, calendar}
    end
  end

  def create_appointment(attrs \\ %{}) do
    %Appointment{}
    |> Appointment.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, appointment} -> {:ok, appointment |> Repo.preload([:dentist, :patient, :scheduler])}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def list_appointments(args) do
    args
    |> appointment_query()
    |> Repo.all()
    |> case do
      [] -> {:ok, []}
      appointments -> {:ok, appointments}
    end
  end

  defp appointment_query(args) do
    Enum.reduce(args, Appointment, fn
      {:filter, filter}, query -> query |> appointment_filter(filter)
    end)
  end

  defp appointment_filter(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:dentist_id, dentist_id}, query ->
        from(q in query, where: q.dentist_id == ^dentist_id)
      {:patient_id, patient_id}, query ->
        from(q in query, where: q.patient_id == ^patient_id)
      {:scheduler_id, scheduler_id}, query ->
        from(q in query, where: q.scheduler_id == ^scheduler_id)
      {:status, status}, query ->
        from(q in query, where: q.status == ^status)
      {:appointment_start_time, range_date}, query ->
        [start_date, end_date] = range_date
        from(q in query, where: q.start_time >= ^start_date and q.start_time <= ^end_date)
      {:appointment_end_time, range_date}, query ->
        [start_date, end_date] = range_date
        from(q in query, where: q.end_time >= ^start_date and q.end_time <= ^end_date)
    end)
  end

  def is_available?(dentist_id, start_time_utc, end_time_utc) do
    with {:ok, calendar} <- get_calendar_by_dentist(dentist_id) |> dbg(),
         # Convertir a zona horaria local
         {:ok, start_time_local} <- convert_to_local(calendar.time_zone, start_time_utc) |> dbg(),
         {:ok, end_time_local} <- convert_to_local(calendar.time_zone, end_time_utc) |> dbg(),
         # Verificar disponibilidad en horario semanal LOCAL
         true <- within_weekly_availability?(calendar, start_time_local, end_time_local),
         # Verificar solapamiento en UTC (la BD almacena UTC)
         false <- appointment_overlaps?(dentist_id, start_time_utc, end_time_utc) do
      true
    else
      {:error, :not_found} -> false
      {:error, _} -> false  # Error en conversión de zona horaria
      false -> false
    end
  end

  # Nueva función para conversión de zona horaria
  defp convert_to_local(time_zone, datetime) do
    case datetime do
      %NaiveDateTime{} = naive_dt ->
        with {:ok, utc_dt} <- DateTime.from_naive(naive_dt, "Etc/UTC"),
             {:ok, local_dt} <- DateTime.shift_zone(utc_dt, time_zone) do
          {:ok, local_dt}
        end

      %DateTime{} = dt ->
        IO.puts("Hola")
        DateTime.shift_zone(dt, time_zone)

      _ ->
        {:error, :invalid_datetime}
    end
  end

  # Ajustada para usar DateTime local
  def within_weekly_availability?(calendar, %DateTime{} = start_time_local, %DateTime{} = end_time_local) do
    # Obtener fecha local (no UTC)
    local_date = DateTime.to_date(start_time_local)
    day_of_week = Date.day_of_week(local_date)

    availability = Enum.find(calendar.weekly_availabilities, fn a ->
      a.day_of_week == day_of_week
    end)

    if availability && !availability.closed do
      # Extraer solo la parte de tiempo local
      start_time_local_only = DateTime.to_time(start_time_local)
      end_time_local_only = DateTime.to_time(end_time_local)

      # Comparar segmentos horarios
      requested_start_sec = time_to_seconds(start_time_local_only)
      requested_end_sec = time_to_seconds(end_time_local_only)
      avail_start_sec = time_to_seconds(availability.start_time)
      avail_end_sec = time_to_seconds(availability.end_time)

      requested_start_sec >= avail_start_sec && requested_end_sec <= avail_end_sec
    else
      false
    end
  end

  # Mantener función original para solapamiento (UTC)
  defp appointment_overlaps?(dentist_id, start_time_utc, end_time_utc) do
    query = from a in Appointment,
      where: a.dentist_id == ^dentist_id,
      where: a.status != 4,
      where: a.start_time < ^end_time_utc and a.end_time > ^start_time_utc

    Repo.exists?(query)
  end

  # Convierte tiempo (HH:MM:SS) a segundos desde medianoche
  defp time_to_seconds(%Time{hour: h, minute: m, second: s}) do
    h * 3600 + m * 60 + s
  end

  defp time_to_seconds(%DateTime{hour: h, minute: m, second: s}) do
    h * 3600 + m * 60 + s
  end
end
