#version 300 es

#define MAX_LIGHTS 16

// struct definitions
struct AmbientLight {
    vec3 color;
    float intensity;
};

struct DirectionalLight {
    vec3 direction;
    vec3 color;
    float intensity;
};

struct PointLight {
    vec3 position;
    vec3 color;
    float intensity;
};

struct Material {
    vec3 kA;
    vec3 kD;
    vec3 kS;
    float shininess;
};


// an attribute will receive data from a buffer
in vec3 a_position;
in vec3 a_normal;

// camera position
uniform vec3 u_eye;

// transformation matrices
uniform mat4x4 u_m;
uniform mat4x4 u_v;
uniform mat4x4 u_p;

// lights and materials
uniform AmbientLight u_lights_ambient[MAX_LIGHTS];
uniform DirectionalLight u_lights_directional[MAX_LIGHTS];
uniform PointLight u_lights_point[MAX_LIGHTS];

uniform Material u_material;

// shading output
out vec4 o_color;

// Shades an ambient light and returns this light's contribution
vec3 shadeAmbientLight(Material material, AmbientLight light) {
    
    // TODO: Implement this method
    vec3 Ia = vec3(0.0, 0.0, 0.0);
    Ia = material.kA * (light.color * light.intensity);
    return Ia;
}

// Shades a directional light and returns its contribution
vec3 shadeDirectionalLight(Material material, DirectionalLight light, vec3 normal, vec3 eye, vec3 vertex_position) {

    // TODO: Implement this methods

    vec3 Id = vec3(0.0, 0.0, 0.0);
    vec3 Is = vec3(0.0, 0.0, 0.0);

    vec3 L = normalize(light.direction);
    float lambertTerm = dot(normal,-L);

    if (lambertTerm > 0.0) {

        vec3 lightReflection = reflect(L, normal);
        float specularCoefficient = pow(max(dot(lightReflection, eye), 0.0), material.shininess);
     
        Id = material.kD * (light.color * light.intensity) * lambertTerm;
        Is = material.kS * (light.color * light.intensity) * specularCoefficient;
    }
    return Id + Is;
}

// Shades a point light and returns its contribution
vec3 shadePointLight(Material material, PointLight light, vec3 normal, vec3 eye, vec3 vertex_position) {

    // TODO: Implement this methods

    vec3 Id = vec3(0.0, 0.0, 0.0);
    vec3 Is = vec3(0.0, 0.0, 0.0);
    
    float distance = length(light.position - vertex_position);

    vec3 vLightRay = vertex_position - light.position;
    vec3 L = normalize(vLightRay);

    float lambertTerm = dot(normal,-L);
    if (lambertTerm > 0.0) {
        vec3 lightReflection = reflect(L, normal);
        float specularCoefficient = pow(max(dot(lightReflection, eye), 0.0), material.shininess);
        Id =  material.kD * (light.color * light.intensity) * lambertTerm;
        Is =  material.kS * (light.color * light.intensity) * specularCoefficient;
    }
    float attenuation = 1.0/(distance*distance+1.0);
    return (Id + Is)*attenuation;
}

void main() {

    // TODO: GORAUD SHADING
    // TODO: Implement the vertex stage
    // TODO: Transform positions and normals
    // NOTE: Normals are transformed differently from positions. Check the book and resources.
    // TODO: Use the above methods to shade every light in the light arrays
    // TODO: Accumulate their contribution and use this total light contribution to pass to o_color

    // TODO: Pass the shaded vertex color to the fragment stage


    vec4 vertex_pos = u_m * vec4(a_position, 1.0);

    mat4 normalMatrix = transpose(inverse(u_m));
    vec3 vNormal = vec3(normalMatrix * vec4(a_normal, 1.0));

    vec3 N = normalize(vNormal);

    vec3 E = normalize(u_eye);

    vec3 aLightTotal = vec3(0.0, 0.0, 0.0);
    vec3 dLightTotal = vec3(0.0, 0.0, 0.0);
    vec3 pLightTotal = vec3(0.0, 0.0, 0.0);


    for (int i = 0; i < MAX_LIGHTS; i++) {
        aLightTotal += shadeAmbientLight(u_material, u_lights_ambient[i]);
        dLightTotal += shadeDirectionalLight(u_material, u_lights_directional[i], N, E, vertex_pos.xyz);
        pLightTotal += shadePointLight(u_material, u_lights_point[i], N, E, vertex_pos.xyz);
    }

    o_color = vec4(vec3(aLightTotal + dLightTotal + pLightTotal), 1.0);
    gl_Position = u_p * u_v * u_m * vec4(a_position, 1.0);
}
