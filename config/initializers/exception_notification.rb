# coding: utf-8
Rails.application.config.middleware.use(
  ExceptionNotifier,
  email_prefix:         "[#{Rails.env}][#{Settings.app_name}] ",
  sender_address:       "rails.dev0115@gmail.com",
  exception_recipients: [ "rails.dev0115@gmail.com" ]
)
