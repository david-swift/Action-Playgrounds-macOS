# Edit the Function

Define the function itself using nodes. Run the function for testing it.

![A Node][image-1]

## Add a Node

Add a node by dragging it from the bar showing the available nodes at the bottom of the window into the editor. There are two views of the node bar: Click on the `↑`/`↓` button next to the bar or use `View > Functions Overview`.

![Connect Parameters][image-2]

## Connect Two Parameters

Connect two parameters by grabbing a circle at the right side of a node, dragging it to a circle with the same color at the left side of another node and releasing it. A line in the color of the circles should be permanently visible between the circles. Now, output data from one parameter is transferred to the other in the execution.

![Manually Set Parameters][image-3]

## Set Parameters Manually

Sometimes, you do not want to use the output of another parameter as the input value of a parameter, but a constant value. For doing that, click on the node and click on the filled circle in the small toolbar or use `View > Actions Visibility > Parameters`, or `Ctrl`-click on the node and select `Parameters`. In the sheet, tick the toggle at the input parameter you want to set manually and set the value using the input method. Close the sheet using `Confirm` or by pressing `↩︎` or `⎋`. The circle at the manually set input parameter should appear smaller, indicating that there is no connection required.

## Delete a Node

Click on the node and click on the `x` button in the small toolbar, or `Ctrl`-click on the node and select `Delete`. The node and its connections should disappear.

![A Node’s Definition][image-4]

## View a Node’s Definition

Click on the node and click on the `{...}` button in the small toolbar or use `View > Actions Visibility > Definition`, or `Ctrl`-click on the node and select `Definition`. If it is one of the default functions, you can see the text `Function defined by the developer.` If you have created and imported the function, you can see the nodes of the function.

![Specify Input Values][image-5]

## Run a Function

For using or testing a function, click on the `Run` button next to the node bar, or using `File > Run` or `⌘R`.

First, a sheet for specifying the input values will appear. Edit the values if necessary and click on `Run` or press `↩︎`.

Then, either an error message or a sheet showing the output values will appear. If an error message appears, try to spot the error and edit your function. Otherwise, use the result or check the function with it. Then, click on `Close` or press `↩︎` or `⎋`.

[image-1]:	../../Icons/Node.png
[image-2]:	../../Icons/ConnectedNodes.png
[image-3]:	../../Icons/SetManually.png
[image-4]:	../../Icons/Definition.png
[image-5]:	../../Icons/Run.png