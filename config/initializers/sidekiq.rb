# Este arquivo roda UMA VEZ quando o Sidekiq (worker) é iniciado
schedule_file = "config/schedule.yml"

# Se o arquivo de agendamento existir...
if File.exist?(schedule_file) && Sidekiq.server?
  # ...carregue-o e diga ao Sidekiq para obedecê-lo.
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
