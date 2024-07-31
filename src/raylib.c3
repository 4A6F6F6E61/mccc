module raylib;

/*
    This file is based on Tsodings raylib.c3:
        https://github.com/tsoding/c3-demo/blob/main/raylib.c3
*/

const Color DARKGRAY = {  80,  80,  80, 255 };
const Color WHITE    = { 255, 255, 255, 255 };
const Color RAYWHITE = { 245, 245, 245, 255 };
const Color GREEN    = {   0, 255,   0, 255 };

def Color   = char[<4>];
def Vector2 = float[<2>];
def Vector3 = float[<3>];
def Vector4 = float[<3>];

def Quaternion = Vector4;
def Texture = Texture2D;
def Camera = Camera3D;

// TODO: Use proper enum, this is only temporary
const int CAMERA_FREE = 1;

struct ColorStruct {
    char r;
    char g;
    char b;
    char a;
}

struct Camera3D {
    Vector3 position;       // Camera position
    Vector3 target;         // Camera target it looks-at
    Vector3 up;             // Camera up vector (rotation over its axis)
    float fovy;             // Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
    int projection;         // Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
}

struct Mesh {
    int vertexCount;        // Number of vertices stored in arrays
    int triangleCount;      // Number of triangles stored (indexed or not)

    // Vertex attributes data
    float *vertices;        // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    float *texcoords;       // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    float *texcoords2;      // Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5)
    float *normals;         // Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
    float *tangents;        // Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
    char *colors;      // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
    ushort *indices;    // Vertex indices (in case vertex data comes indexed)

    // Animation vertex data
    float *animVertices;    // Animated vertex positions (after bones transformations)
    float *animNormals;     // Animated normals (after bones transformations)
    char *boneIds; // Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning)
    float *boneWeights;     // Vertex bone weight, up to 4 bones influence by vertex (skinning)

    // OpenGL identifiers
    uint vaoId;     // OpenGL Vertex Array Object id
    uint *vboId;    // OpenGL Vertex Buffer Objects id (default vertex data)
}

// Model, meshes, materials and animation data
struct Model {
    Matrix transform;       // Local transform matrix

    int meshCount;          // Number of meshes
    int materialCount;      // Number of materials
    Mesh *meshes;           // Meshes array
    Material *materials;    // Materials array
    int *meshMaterial;      // Mesh material number

    // Animation data
    int boneCount;          // Number of bones
    BoneInfo *bones;        // Bones information (skeleton)
    Transform *bindPose;    // Bones base transformation (pose)
}

// Matrix, 4x4 components, column major, OpenGL style, right-handed
struct Matrix {
    float m0, m4, m8, m12;  // Matrix first row (4 components)
    float m1, m5, m9, m13;  // Matrix second row (4 components)
    float m2, m6, m10, m14; // Matrix third row (4 components)
    float m3, m7, m11, m15; // Matrix fourth row (4 components)
}

// MaterialMap
struct MaterialMap {
    Texture2D texture;      // Material map texture
    Color color;            // Material map color
    float value;            // Material map value
}

// Material, includes shader and maps
struct Material {
    Shader shader;          // Material shader
    MaterialMap *maps;      // Material maps array (MAX_MATERIAL_MAPS)
    float[4] params;        // Material generic parameters (if required)
}

// Transform, vertex transformation data
struct Transform {
    Vector3 translation;    // Translation
    Quaternion rotation;    // Rotation
    Vector3 scale;          // Scale
}

// Bone, skeletal animation bone
struct BoneInfo {
    char[32] name;          // Bone name
    int parent;             // Bone parent
}

// Texture, tex data stored in GPU memory (VRAM)
struct Texture2D {
    uint id;                // OpenGL texture id
    int width;              // Texture base width
    int height;             // Texture base height
    int mipmaps;            // Mipmap levels, 1 by default
    int format;             // Data format (PixelFormat type)
}

// Shader
struct Shader {
    uint id;                // Shader program id
    int *locs;              // Shader locations array (RL_MAX_SHADER_LOCATIONS)
}

extern fn void init_window(int width, int height, char *title) @extern("InitWindow");
extern fn void close_window() @extern("CloseWindow");
extern fn void set_target_fps(int fps) @extern("SetTargetFPS");
extern fn bool window_should_close() @extern("WindowShouldClose");
extern fn void begin_drawing() @extern("BeginDrawing");
extern fn void clear_background(char[4] color) @extern("ClearBackground");
extern fn void end_drawing() @extern("EndDrawing");
extern fn void draw_rectangle(int posX, int posY, int width, int height, Color color) @extern("DrawRectangle");
extern fn float get_frame_time() @extern("GetFrameTime");
extern fn void draw_rectangle_v(float[2] position, float[2] size, char[4] color) @extern("DrawRectangleV");
extern fn int get_screen_width() @extern("GetScreenWidth");
extern fn int get_screen_height() @extern("GetScreenHeight");
extern fn Color color_from_hsv(float hue, float saturation, float value) @extern("ColorFromHSV");
extern fn int get_random_value(int min, int max) @extern("GetRandomValue");
extern fn void upload_mesh(Mesh *mesh, bool dynamic) @extern("UploadMesh");
extern fn void unload_model(Model model) @extern("UnloadModel");
extern fn void draw_text(char *text, int posX, int posY, int fontSize, char[4] color) @extern("DrawText");
extern fn void begin_mode_3D(Camera3D camera) @extern("BeginMode3D");
extern fn void end_mode_3D() @extern("EndMode3D");
extern fn void draw_model(Model model, Vector3 position, float scale, char[4] tint) @extern("DrawModel");
extern fn void update_camera(Camera *camera, int mode) @extern("UpdateCamera");
extern fn Model load_model_from_mesh(Mesh mesh) @extern("LoadModelFromMesh");
