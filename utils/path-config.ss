;; -*- Gerbil -*-
;; Path configuration.

(export #t)

(import
  :clan/utils/base :clan/utils/config :clan/utils/filesystem :clan/utils/path)

;; These paths should be defined or redefined somewhere in your application,
;; typically with e.g.
;;   (set! application-source-envvar "MY_APP_SOURCE")
;;   (set! application-home-envvar "MY_APP_HOME")
(def application-source-envvar (values "GERBIL_APPLICATION_SOURCE"))
(def application-home-envvar (values "GERBIL_APPLICATION_HOME"))
(def source-directory (values (λ () (getenv application-source-envvar))))
(def home-directory (values (λ () (getenv application-home-envvar))))
(def bin-directory (values (λ () (path-expand ".build_outputs" (source-directory))))) ;; executables
(def cache-directory (values (λ () (path-expand "cache" (home-directory))))) ;; dynamic cache
(def config-directory (values (λ () (path-expand "config" (home-directory))))) ;; configuration files
(def data-directory (values (λ () (path-expand "data" (home-directory))))) ;; static data
(def run-directory (values (λ () (path-expand "run" (home-directory))))) ;; transient state

(def (bin-path . x) (apply subpath (bin-directory) x))
(def (cache-path . x) (apply subpath (cache-directory) x))
(def (config-path . x) (apply subpath (config-directory) x))
(def (data-path . x) (apply subpath (data-directory) x))
(def (run-path . x) (apply subpath (run-directory) x))
(def (source-path . x) (apply subpath (source-directory) x))
