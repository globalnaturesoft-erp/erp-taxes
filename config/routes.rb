Erp::Taxes::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/taxes" do
      resources :taxes do
        collection do
          post 'list'
          get 'dataselect'
          put 'archive_all'
          put 'unarchive_all'
          put 'archive'
          put 'unarchive'
          put 'set_active'
          put 'set_deleted'
        end
      end
    end
	end
end