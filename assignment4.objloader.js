import { loadExternalFile } from './js/utils/utils.js'

/**
 * A class to load OBJ files from disk
 */
class OBJLoader {

    /**
     * Constructs the loader
     * 
     * @param {String} filename The full path to the model OBJ file on disk
     */
    constructor(filename) {
        this.filename = filename
    }

    /**
     * Loads the file from disk and parses the geometry
     * 
     * @returns {[Array<Number>, Array<Number>]} A tuple / list containing 1) the list of vertices and 2) the list of triangle indices
     */
    load() {

        // Load the file's contents
        let contents = loadExternalFile(this.filename);

        // Create lists for vertices and indices
        let vertices = [];
        let indices = [];

        // TODO: STEP 1
        // Parse the file's contents
        // You can loop through the file line-by-line by splitting the string at line breaks
        let lines = contents.split('\n');
        

        // TODO: STEP 2
        // Process (or skip) each line based on its content and call the parsing functions to parse an entry
        // For vertices call OBJLoader.parseVertex
        // For faces call OBJLoader.parseFace
        for (let line of lines) {
            let ch = line.split(' ')[0];
            if (ch == 'v') {
                vertices.push(...this.parseVertex(line)) ;
            } 
            else if (ch == 'f') {
                indices.push(...this.parseFace(line));
            }
        }

        // TODO: STEP 3
        // Vertex coordinates can be arbitrarily large or small
        // We want to normalize the vertex coordinates to fit within our [-1.0, 1.0]^3 box from the previous assignment
        // As a pre-processing step and to avoid complicated scaling transformations in the main app we perform normalization here
        // Determine the max and min extent of all the vertex coordinates and normalize each entry based on this finding
        function getMax(arr) {
            let len = arr.length;
            let curMax = -Infinity;
            while (len--) {
                if (arr[len] > curMax){
                    curMax = arr[len]
                }
            }
            return curMax;
        }
        function getMin(arr) {
            let len = arr.length;
            let curMin = Infinity;
            while (len--) {
                if (arr[len] < curMin){
                    curMin = arr[len]
                }
            }
            return curMin;
        }
        let minV = getMin(vertices);
        let maxV = getMax(vertices);
        for (let i = 0; i < vertices.length; i++) {
            vertices[i] = 2*((vertices[i] - minV) / (maxV - minV)) - 1;
        }

        // TODO: HINT
        // Look up the JavaScript functions String.split, parseFloat, and parseInt 
        // You will need thim in your parsing functions

        // Return the tuple
        return [ vertices, indices ];
    }

    /**
     * Parses a single OBJ vertex entry given as a string
     * Call this function from OBJLoader.load()
     * 
     * @param {String} vertex_string String containing the vertex entry 'v {x} {y} {z}'
     * @returns {Array<Number>} A list containing the x, y, z coordinates of the vertex
     */
    parseVertex(vertex_string)
    {
        let lineArray = vertex_string.split(' ');
        return [parseFloat(lineArray[1]), parseFloat(lineArray[2]), parseFloat(lineArray[3])];

        // TODO: Process the entry and parse numbers to float
    }

    /**
     * Parses a single OBJ face entry given as a string
     * Face entries can refer to 3 or 4 elements making them triangle or quad faces
     * WebGL only supports triangle drawing, so we need to triangulate the entry if we find 4 indices
     * This is done using OBJLoader.triangulateFace()
     * 
     * Each index entry can have up to three components separated by '/' 
     * You need to grad the first component. The other ones are for textures and normals which will be treated later
     * Make sure to account for this fact.
     * 
     * Call this function from OBJLoader.load()
     * 
     * @param {String} face_string String containing the face entry 'f {v0}/{vt0}/{vn0} {v1}/{vt1}/{vn1} {v2}/{vt2}/{vn2} ({v3}/{vt3}/{vn3})'
     * @returns {Array<Number>} A list containing three indices defining a triangle
     */
    parseFace(face_string)
    {
        let lineArray = face_string.split(' ');
        if (lineArray.length == 4){ //triangle face
            return [parseInt(lineArray[1].split('/')[0])-1, 
                              parseInt(lineArray[2].split('/')[0])-1, 
                              parseInt(lineArray[3].split('/')[0])-1];
        }
        else if (lineArray.length == 5){ //quad face
            let triangulated = this.triangulateFace([parseInt(lineArray[1].split('/')[0])-1, 
                                                          parseInt(lineArray[2].split('/')[0])-1, 
                                                          parseInt(lineArray[3].split('/')[0])-1,
                                                          parseInt(lineArray[4].split('/')[0])-1]);
            return triangulated;
        }
        // TODO: Process the entry and parse numbers to ints
        // TODO: Don't forget to handle triangulation if quads are given
    }

    /**
     * Triangulates a face entry given as a list of 4 indices
     * Use these 4 indices to create indices for two separate triangles that share a side (2 vertices)
     * Return a new index list containing the triangulated indices
     * 
     * @param {Array<Number>} face The quad indices with 4 entries
     * @returns {Array<Number>} The newly created list containing triangulated indices
     */
    triangulateFace(face)
    {
        return [face[0], face[1], face[2], face[1], face[2], face[3]];

        // TODO: Triangulate the face indices
    }
}

export {
    OBJLoader
}
