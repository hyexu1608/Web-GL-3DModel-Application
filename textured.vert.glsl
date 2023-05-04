#version 300 es

// an attribute will receive data from a buffer
in vec3 a_position;
in vec3 a_normal;
in vec3 a_tangent;
in vec2 a_texture_coord;

// transformation matrices
uniform mat4x4 u_m;
uniform mat4x4 u_v;
uniform mat4x4 u_p;

// output to fragment stage
// Create varyings to pass data to the fragment stage (position, texture coords, and more)

out vec3 o_vertex_position_world;
out mat3 TBN;
out vec2 vTextureCoords;


void main() {

    // transform a vertex from object space directly to screen space
    // the full chain of transformations is:
    // object space -{model}-> world space -{view}-> view space -{projection}-> clip space
    vec4 vertex_position_world = u_m * vec4(a_position, 1.0);

    // Construct TBN matrix from normals, tangents and bitangents
    // Use the Gram-Schmidt process to re-orthogonalize tangents
    // do all calculations in world space using the TBN to transform normals
    // Refer to https://learnopengl.com/Advanced-Lighting/Normal-Mapping for all above

    mat3 norm_matrix = transpose(inverse(mat3(u_m)));

    vec3 T = normalize(vec3(vec4(norm_matrix * a_tangent, 0.0)));
    vec3 N = normalize(vec3(vec4(norm_matrix * a_normal, 0.0)));
    // re-orthogonalize T with respect to N
    T = normalize(T - dot(T, N) * N);
    // then retrieve perpendicular vector B with the cross product of T and N
    vec3 B = cross(N, T);
    TBN = mat3(T, B, N);

    // Forward data to fragment stage

    gl_Position = u_p * u_v * vertex_position_world;
    vTextureCoords = a_texture_coord;
    o_vertex_position_world = vertex_position_world.xyz;

}