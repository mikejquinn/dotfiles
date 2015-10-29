{:user {:plugins [[cider/cider-nrepl "0.9.1"]]
        :dependencies [[com.cemerick/piggieback "0.2.1"]
                       [org.clojure/tools.nrepl "0.2.10"]]
        :repl-options {:nrepl-middleware [cemerick.piggieback/wrap-cljs-repl]}}
 :auth {:repository-auth {#"https://clojars.org/repo" {:username "mikeq"
                                                       :password "k9o3fs68W36zE82Le"}}}}
                  ;[lein-pprint "1.1.1"]
