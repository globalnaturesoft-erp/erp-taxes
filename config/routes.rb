Erp::Taxes::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/taxes" do
      resources :taxes do
        collection do
          post 'list'
          get 'dataselect'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
        end
      end
    end
	end
end