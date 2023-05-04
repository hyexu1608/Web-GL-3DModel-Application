#version 300 es

#define MAX_LIGHTS 16

// Fragment shaders don't have a default precision so we need
// to pick one. mediump is a good default. It means "medium precision".
precision mediump float;

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

// lights and materials
uniform AmbientLight u_lights_ambient[MAX_LIGHTS];
uniform DirectionalLight u_lights_directional[MAX_LIGHTS];
uniform PointLight u_lights_point[MAX_LIGHTS];

uniform Material u_material;

// camera position
uniform vec3 u_eye;

// received from vertex stage
// TODO: Create any needed `in` variables here
// TODO: These variables correspond to the `out` variables from the vertex stage

in vec3 vNormal;
in vec3 vertex_pos;




// with webgl 2, we now have to define an out that will be the color of the fragment
out vec4 o_fragColor;

// Shades an ambient light and returns this light's contribution
vec3 shadeAmbientLight(Material material, AmbientLight light) {
    vec3 Ia = vec3(0.0, 0.0, 0.0);
    Ia = material.kA * (light.color * light.intensity);
    return Ia;
}

// Shades a directional light and returns its contribution
vec3 shadeDirectionalLight(Material material, DirectionalLight light, vec3 normal, vec3 eye, vec3 vertex_position) {
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

    // TODO: PHONG SHADING
    // TODO: Implement the fragment stage
    // TODO: Use the above methods to shade every light in the light arrays
    // TODO: Accumulate their contribution and use this total light contribution to pass to o_fragColor

    // TODO: Pass the shaded vertex color to the output



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


    o_fragColor = vec4(vec3(aLightTotal + dLightTotal + pLightTotal), 1.0);
}
