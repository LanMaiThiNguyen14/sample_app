Rails.application.routes.draw doroot 'static_pages#home'
  scope "(:locale)", locale: /en|vi/ do
  root"static_pages#home"
  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"
  get "static_pages/contact"
end
