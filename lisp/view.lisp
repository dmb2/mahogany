(in-package #:mahogany)

(cffi:defcallback handle-new-view-event :void
    ((view (:pointer (:struct hrt:hrt-view))))
  (log-string :trace "New view callback called!")
  (mahogany-state-view-add *compositor-state* view))

(cffi:defcallback handle-view-destroyed-event :void
    ((view (:pointer (:struct hrt:hrt-view))))
  (log-string :trace "View destroyed callback called!")
  (mahogany-state-view-remove *compositor-state*  view))
