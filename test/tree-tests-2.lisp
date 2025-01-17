(fiasco:define-test-package #:mahogany-tests/tree-2
  (:local-nicknames (#:tree #:mahogany/tree))
  (:use #:mahogany/wm-interface #:mahogany/wm-interface))

(in-package #:mahogany-tests/tree-2)

(defun make-tree-for-tests (&key (x 0) (y 0) (width 100) (height 100))
  (multiple-value-bind (container frame) (mahogany/tree:make-basic-tree :x x
									:y y
									:width width
									:height height)
    (values frame container)))

(defun make-tree-frame (children &key split-direction (x 0) (y 0) (width 100) (height 100))
  (let ((parent (make-instance  'tree:tree-frame
				:x x :y y
				:width width :height height
				:split-direction split-direction)))
    (dolist (c children)
      (setf (tree:frame-parent c) parent))
    (setf (tree:tree-children parent) children)
    parent))

(fiasco:deftest set-position-view-frame ()
  (let ((tree (make-tree-for-tests :x 0 :y 0)))
    (set-position tree 100 200)
    (is (= (tree:frame-x tree) 100))
    (is (= (tree:frame-y tree) 200))))

(fiasco:deftest set-position-tree-frame ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 0 :y 0 :width 50 :height 100))
	 (child-2 (make-instance 'tree:view-frame :x 51 :y 0 :width 50 :height 100))
	 (parent (make-tree-frame (list child-1 child-2) :split-direction :horizontal)))
    (set-position parent 100 200)
    (is (= (tree:frame-x child-1) 100))
    (is (= (tree:frame-y child-1) 200))
    (is (= (tree:frame-x child-2) 151))
    (is (= (tree:frame-y child-2) 200))))

(fiasco:deftest setf-frame-x-view-frame-sets-value ()
  (let ((tree (make-tree-for-tests :x 0 :y 0)))
    (setf (tree:frame-x tree) 100)
    (is (= 100 (tree:frame-x tree)))))

(fiasco:deftest setf-frame-y-view-frame-sets-value ()
  (let ((tree (make-tree-for-tests :x 0 :y 0)))
    (setf (tree:frame-y tree) 223)
    (is (= (tree:frame-y tree) 223))))

(fiasco:deftest setf-frame-y-tree-frame ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 0 :y 0 :width 50 :height 100))
	 (child-2 (make-instance 'tree:view-frame :x 51 :y 0 :width 50 :height 100))
	 (parent (make-tree-frame (list child-1 child-2) :split-direction :horizontal)))
    (setf (tree:frame-y parent) 100)
    (is (= (tree:frame-x parent) 0))
    (is (= (tree:frame-y parent) 100))
    (is (= (tree:frame-x child-1) 0))
    (is (= (tree:frame-y child-2) 100))
    (is (= (tree:frame-x child-2) 51))))

(fiasco:deftest setf-frame-x-tree-frame ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 0 :y 0 :width 50 :height 100))
	 (child-2 (make-instance 'tree:view-frame :x 51 :y 0 :width 50 :height 100))
	 (parent (make-tree-frame (list child-1 child-2) :split-direction :horizontal)))
    (setf (tree:frame-x parent) 100)
    (is (= (tree:frame-x parent) 100))
    (is (= (tree:frame-y parent) 0))
    (is (= (tree:frame-x child-1) 100))
    (is (= (tree:frame-y child-2) 0))
    (is (= (tree:frame-x child-2) 151))))

(fiasco:deftest setf-frame-width-view-frame ()
  (let ((tree (make-tree-for-tests :x 10 :y 15 :width 100 :height 100)))
    (setf (tree:frame-width tree) 40)
    (is (= (tree:frame-width tree) 40))
    (is (= (tree:frame-height tree) 100))))

(fiasco:deftest setf-frame-height-view-frame ()
  (let ((tree (make-tree-for-tests :x 10 :y 15 :width 100 :height 100)))
    (setf (tree:frame-height tree) 40)
    (is (= (tree:frame-height tree) 40))
    (is (= (tree:frame-width tree) 100))))

(fiasco:deftest setf-frame-width-horizontal-tree-frame ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 25 :y 15 :width 50 :height 100))
	 (child-2 (make-instance 'tree:view-frame :x 75 :y 15 :width 50 :height 100))
	 (parent (make-tree-frame (list child-1 child-2) :x 25 :y 15 :split-direction :horizontal)))
    (setf (tree:frame-width parent) 50)
    (is (= (tree:frame-height parent) 100))
    (is (= (tree:frame-height child-1) 100))
    (is (= (tree:frame-height child-2) 100))
    (is (= (tree:frame-width parent) 50))
    (is (= (tree:frame-width child-1) 25))
    (is (= (tree:frame-width child-2) 25))
    (is (= (tree:frame-x child-1) 25))
    (is (= (tree:frame-x child-2) 50))
    (is (= (tree:frame-y child-1) 15))
    (is (= (tree:frame-y child-2) 15))))

(fiasco:deftest setf-frame-width-vertical-tree-frame ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 25 :y 15 :width 100 :height 50))
	 (child-2 (make-instance 'tree:view-frame :x 25 :y 65 :width 100 :height 50))
	 (parent (make-tree-frame (list child-1 child-2) :x 25 :y 15 :split-direction :vertical)))
    (setf (tree:frame-width parent) 50)
    (is (= (tree:frame-height parent) 100))
    (is (= (tree:frame-height child-1) 50))
    (is (= (tree:frame-height child-2) 50))
    (is (= (tree:frame-width parent) 50))
    (is (= (tree:frame-width child-1) 50))
    (is (= (tree:frame-width child-2) 50))
    (is (= (tree:frame-x child-1) 25))
    (is (= (tree:frame-x child-2) 25))
    (is (= (tree:frame-y child-1) 15))
    (is (= (tree:frame-y child-2) 65))))

(fiasco:deftest setf-frame-height-vertical-tree-frame ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 25 :y 15 :width 100 :height 50))
	 (child-2 (make-instance 'tree:view-frame :x 25 :y 65 :width 100 :height 50))
	 (parent (make-tree-frame (list child-1 child-2) :x 25 :y 15 :split-direction :vertical)))
    (setf (tree:frame-height parent) 50)
    (is (= (tree:frame-width parent) 100))
    (is (= (tree:frame-width child-1) 100))
    (is (= (tree:frame-width child-2) 100))
    (is (= (tree:frame-height parent) 50))
    (is (= (tree:frame-height child-1) 25))
    (is (= (tree:frame-height child-2) 25))
    (is (= (tree:frame-x child-1) 25))
    (is (= (tree:frame-x child-2) 25))
    (is (= (tree:frame-y child-1) 15))
    (is (= (tree:frame-y child-2) 40))))

(fiasco:deftest setf-frame-height-horizontal-tree-frame ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 25 :y 15 :width 100 :height 50))
	 (child-2 (make-instance 'tree:view-frame :x 25 :y 65 :width 100 :height 50))
	 (parent (make-tree-frame (list child-1 child-2) :x 25 :y 15 :split-direction :horizontal)))
    (setf (tree:frame-height parent) 50)
    (is (= (tree:frame-width parent) 100))
    (is (= (tree:frame-width child-1) 100))
    (is (= (tree:frame-width child-2) 100))
    (is (= (tree:frame-height parent) 50))
    (is (= (tree:frame-height child-1) 25))
    (is (= (tree:frame-height child-2) 25))
    (is (= (tree:frame-x child-1) 25))
    (is (= (tree:frame-x child-2) 25))
    (is (= (tree:frame-y child-1) 15))
    (is (= (tree:frame-y child-2) 65))))

(fiasco:deftest single-frame--frame-at-test ()
  (let ((frame (make-instance 'tree:frame :x 0 :y 0 :width 100 :height 100)))
    (is (equal frame (tree:frame-at frame 50 50)))
    (is (not (tree:frame-at frame -1 50)))
    (is (not (tree:frame-at frame 50 -1)))
    (is (not (tree:frame-at frame -1 -1)))))

(fiasco:deftest set-dimensions-frame ()
  (let ((frame (make-instance 'tree:frame :x 0 :y 0 :width 100 :height 100)))
    (set-dimensions frame 400 200)
    (is (= (tree:frame-width frame) 400))
    (is (= (tree:frame-height frame) 200))))

(fiasco:deftest set-dimensions-tree-frame-width-change ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 0 :y 0 :width 50 :height 100))
	 (child-2 (make-instance 'tree:view-frame :x 50 :y 0 :width 50 :height 100))
	 (parent (make-tree-frame (list child-1 child-2) :height 100 :width 100
				  :split-direction :horizontal)))
    (set-dimensions parent 200 400)
    (is (= (tree:frame-width parent) 200))
    (is (= (tree:frame-height parent) 400))
    (is (= (tree:frame-width child-1) 100))
    (is (= (tree:frame-height child-1) 400))
    (is (= (tree:frame-width child-2) 100))
    (is (= (tree:frame-height child-2) 400))))

(fiasco:deftest set-dimensions-tree-frame-height-change ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 0 :y 0 :width 100 :height 50))
	 (child-2 (make-instance 'tree:view-frame :x 0 :y 50 :width 100 :height 50))
	 (parent (make-tree-frame (list child-1 child-2) :height 100 :width 100
				  :split-direction :vertical)))
    (set-dimensions parent 200 400)
    (is (= (tree:frame-width parent) 200))
    (is (= (tree:frame-height parent) 400))
    (is (= (tree:frame-width child-1) 200))
    (is (= (tree:frame-height child-1) 200))
    (is (= (tree:frame-width child-2) 200))
    (is (= (tree:frame-height child-2) 200))))

(fiasco:deftest set-dimensions-tree-frame-chidren-move-x ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 0 :y 0 :width 50 :height 100))
	 (child-2 (make-instance 'tree:view-frame :x 50 :y 0 :width 50 :height 100))
	 (parent (make-tree-frame (list child-1 child-2) :height 100 :width 100
				  :split-direction :horizontal)))
    (set-dimensions parent 200 400)
    (is (= (tree:frame-x parent) 0))
    (is (= (tree:frame-y parent) 0))
    (is (= (tree:frame-x child-1) 0))
    (is (= (tree:frame-y child-1) 0))
    (is (= (tree:frame-x child-2) 100))
    (is (= (tree:frame-y child-2) 0))))

(fiasco:deftest set-dimensions-tree-frame-chidren-move-y ()
  (let* ((child-1 (make-instance 'tree:view-frame :x 20 :y 0 :width 100 :height 50))
	 (child-2 (make-instance 'tree:view-frame :x 20 :y 50 :width 100 :height 50))
	 (parent (make-tree-frame (list child-1 child-2) :x 20 :y 0 :height 100 :width 100
				  :split-direction :vertical)))
    (set-dimensions parent 200 400)
    (is (= (tree:frame-x parent) 20))
    (is (= (tree:frame-y parent) 0))
    (is (= (tree:frame-x child-1) 20))
    (is (= (tree:frame-y child-1) 0))
    (is (= (tree:frame-x child-2) 20))
    (is (= (tree:frame-y child-2) 200))))
