This project implements a WebGL application that can load, render, and manipulate 3D scenes with lighting, shading, materials and textures. The 3D models are stored in OBJ format. The 3D scene, represented in JSON format, consists of 3d models and a scenegraph in which those objects are arranged.
* Arcball camera interaction using the mouse. Pan and Rotate relative to the current camera view. Zooming move the view towards the view's center.
*	Local transformations of scene nodes using the mouse. Translations and Rotations relative to the current camera view. Scaling local to the object.

## OBJ and Scene Files
### Models
Folder "./models" has some popular 3D models used throughout industry and research by institutions like NVIDIA, Intel, Stanford, CMU, Meta and more.
https://www.turbosquid.comLinks. 
https://www.cgtrader.comLinks.
https://sketchfab.com/3d-modelsLinks. 
to find free models online.
### Scenes
A scene is in the JSON format. Sample scenes are stored in "./scenes". 1) Model definitions that define the 3d models (OBJs) and 2) a scene graph that places these models in the scene. Nodes that are either fully virtual or contain a model. Each node has at least a name, type and transformation.

## About lighting
A new node type to represent lights. All scenes contain basic lighting setups.
The new resource section is called "lights" and contains definitions for lights. Each light has: Name, Type, Color, Intensity.
Lights can be added to a scene using the new light node type. A light node will be of "type": "light" and refer to a light resource in its "content" field. Shaders will support ambient, directional, and point lights.

## About texture
The main, file-type wise, are MTL files and jpg/png images.
When you look at the file spec you'll see that there are hundreds of options to define materials in MTL. We will be limiting ourselves to just a few to realize our shading. "newmtl" Defines a new material entry (MTLs can store multiple materials). 
•	"Ka" - The ambient component of the material 
•	"Kd" - The diffuse component of the material
•	"Ks" - The specular component of the material
•	"Ns" - The shininess factor for the specular component
•	"map_Kd" - Image textures for the model
•	"map_Ns" - Roughness maps
•	"map_bump" / "bump" / "norm" - Normal maps
  
  
In OBJs we use two main entries to set materials for objects:
•	"mtllib" - Points to the MTL file that contains the above material definitions
•	"usemtl" - Placed before "f" entries to assign a specific material for a number of face
