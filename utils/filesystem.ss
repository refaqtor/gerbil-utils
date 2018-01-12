;; -*- Gerbil -*-
;;;; Utilities to interface the filesystem

(export #t)

(import
  :gerbil/gambit/exceptions :gerbil/gambit/os :gerbil/gambit/ports
  :std/misc/list :std/srfi/1 :std/sugar
  :clan/utils/base :clan/utils/list)

(def (subpath top . sub-components)
  (path-expand (string-join sub-components "/") top))

(def (path-is-symlink? path)
  (equal? 'symbolic-link (file-info-type (file-info path #f))))

(def (path-is-not-symlink? path)
  (not (path-is-symlink? path)))

(def (path-is-file? path (follow-symlinks? #f))
  (equal? 'regular (file-info-type (file-info path follow-symlinks?))))

(def (path-is-directory? path (follow-symlinks? #f))
  (equal? 'directory (file-info-type (file-info path follow-symlinks?))))

;; Given a path, visit the path.
;; When the path is a directory and recurse? returns true when called with the path,
;; recurse on the files under the directory.
;; To collect files, poke a list-builder in the visit function.
(def (walk-filesystem-tree!
      path
      visit
      recurse?: (recurse? true)
      follow-symlinks?: (follow-symlinks? #f))
  (visit path)
  (when (and (ignore-errors (path-is-directory? path follow-symlinks?))
             (recurse? path))
    (for-each!
     (directory-files path)
     (λ (name) (walk-filesystem-tree!
                (path-expand name path) visit
                recurse?: recurse? follow-symlinks?: follow-symlinks?)))))

;; find-files: traverse the filesystem and collect files that satisfy some predicates
;; path: a string that indicates the start point of the recursive filesystem traversal
;; pred?: a predicate that given a path returns true if the path shall be collected
;; recurse?: a function that gigven a path returns true if the traversal shall recurse
;; follow-symlinks?: a boolean that is true if the traversal shall recurse into symlinks
(def (find-files path
                 (pred? true)
                 recurse?: (recurse? true)
                 follow-symlinks?: (follow-symlinks? #f))
  (with-list-builder (collect!)
    (walk-filesystem-tree! path
     (λ (file) (when (pred? file) (collect! file)))
     recurse?: recurse?
     follow-symlinks?: follow-symlinks?)))

(def (total-file-size list-of-files)
  (reduce + 0 (map file-size list-of-files)))
