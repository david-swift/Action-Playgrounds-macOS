# Selection

Selection is the execution of one part of the function at a certain state and another part at another state. Here is an example.

![Selection][image-1]

In this example, the input of the function is a boolean. If the boolean is true, the upper “Add Text” has to be executed. Otherwise, it is the lower “Add Text”. We accomplish that by converting the boolean into a control flow value for the upper “Add Text” and by converting the inverted boolean into a control flow value for the lower “Add Text”. A control flow value is either “Signal” or “No Signal”. Only if the node gets “Signal”, it gets executed. In that example, it is always only one of the “Add Text” nodes. Then, we need to merge the two results, that means connecting the two pathways to end both at the output node, or, in that case, for example at another “Add Text” node. The “Merge” nodes output the input value that is first available, ignoring the other one.

Selection always involves at least two “Boolean to Control Flow” nodes and one “Merge” node.

[image-1]:	../../Icons/Selection.png