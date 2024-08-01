module voxel;
import raylib;

struct Voxel {
    Vector3 position;
    Color color;
}

fn raylib::Mesh generate_voxel_mesh(Voxel *voxels, int voxelCount) {
    // Each voxel has 6 faces, 2 triangles per face, 3 vertices per triangle
    int faceCount = 6;
    int trianglesPerFace = 2;
    int verticesPerTriangle = 3;
    int verticesCount = voxelCount * faceCount * trianglesPerFace * verticesPerTriangle;

    // Allocate memory for vertices, normals, texcoords, and colors
    float *vertices = malloc((long)verticesCount * 3 * float.sizeof);
    float *normals = malloc((long)verticesCount * 3 * float.sizeof);
    float *texcoords = malloc((long)verticesCount * 2 * float.sizeof);
    char *colors = malloc((long)verticesCount * 4 * char.sizeof);

    int vertexIndex = 0;

    // Define the vertices for a unit cube centered at the origin
    Vector3[8] cubeVertices = {
        { -0.5, -0.5, -0.5 }, { 0.5, -0.5, -0.5 },
        { 0.5, 0.5, -0.5 }, { -0.5, 0.5, -0.5 },
        { -0.5, -0.5, 0.5 }, { 0.5, -0.5, 0.5 },
        { 0.5, 0.5, 0.5 }, { -0.5, 0.5, 0.5 }
    };

    // Define the indices for each face of the cube
    int[6][6] cubeFaces = {
        { 0, 1, 2, 2, 3, 0 }, // Front
        { 4, 5, 6, 6, 7, 4 }, // Back
        { 0, 1, 5, 5, 4, 0 }, // Bottom
        { 2, 3, 7, 7, 6, 2 }, // Top
        { 0, 3, 7, 7, 4, 0 }, // Left
        { 1, 2, 6, 6, 5, 1 }  // Right
    };

    // Define normals for each face
    Vector3[6] faceNormals = {
        { 0.0, 0.0, -1.0 }, // Front
        { 0.0, 0.0, 1.0 },  // Back
        { 0.0, -1.0, 0.0 }, // Bottom
        { 0.0, 1.0, 0.0 },  // Top
        { -1.0, 0.0, 0.0 }, // Left
        { 1.0, 0.0, 0.0 }   // Right
    };

    // Define texture coordinates for each vertex of a face
    float[2][6] faceTexcoords = {
        { 0.0, 0.0 }, { 1.0, 0.0 }, { 1.0, 1.0 },
        { 1.0, 1.0 }, { 0.0, 1.0 }, { 0.0, 0.0 }
    };

    float[1][2][3] test = {
        {
            {1},
            {1},
        },
        {
            {1},
            {1},
        },
        {
            {1},
            {1},
        }
    };

    for (int i = 0; i < voxelCount; i++) {
        Voxel voxel = voxels[i];

        for (int face = 0; face < faceCount; face++) {
            for (int j = 0; j < 6; j++) {
                Vector3 vertex = cubeVertices[cubeFaces[face][j]];

                vertices[vertexIndex * 3] = voxel.position.x + vertex.x;
                vertices[vertexIndex * 3 + 1] = voxel.position.y + vertex.y;
                vertices[vertexIndex * 3 + 2] = voxel.position.z + vertex.z;

                normals[vertexIndex * 3] = faceNormals[face].x;
                normals[vertexIndex * 3 + 1] = faceNormals[face].y;
                normals[vertexIndex * 3 + 2] = faceNormals[face].z;

                texcoords[vertexIndex * 2] = faceTexcoords[j][0];
                texcoords[vertexIndex * 2 + 1] = faceTexcoords[j][1];

                colors[vertexIndex * 4] = voxel.color.r;
                colors[vertexIndex * 4 + 1] = voxel.color.g;
                colors[vertexIndex * 4 + 2] = voxel.color.b;
                colors[vertexIndex * 4 + 3] = voxel.color.a;

                vertexIndex++;
            }
        }
    }

    Mesh mesh;
    mesh.vertexCount = verticesCount;
    mesh.triangleCount = verticesCount / 3;

    mesh.vertices = vertices;
    mesh.normals = normals;
    mesh.texcoords = texcoords;
    mesh.colors = colors;

    raylib::upload_mesh(&mesh, true);

    return mesh;
}

// Function to create a mesh from voxels
fn raylib::Mesh generate_voxel_mesh_old(Voxel *voxels, int voxelCount) {
    int verticesCount = voxelCount * 36; // 6 faces * 2 triangles * 3 vertices
    float *vertices = malloc((long)verticesCount * 3 * float.sizeof);
    float *normals = malloc((long)verticesCount * 3 * float.sizeof);
    float *texcoords = malloc((long)verticesCount * 2 * char.sizeof);
    char *colors = malloc((long)verticesCount * 4 * char.sizeof);

    int vertexIndex = 0;

    for (int i = 0; i < voxelCount; i++) {
        Voxel voxel = voxels[i];

        int[3] x = { 1, 2, 3 };

        Vector3[36] cubeVertices;

        int iota = 0;

        cubeVertices[iota++] = { voxel.position.x - 0.5, voxel.position.y - 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x + 0.5, voxel.position.y - 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x + 0.5, voxel.position.y + 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x - 0.5, voxel.position.y - 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x + 0.5, voxel.position.y + 0.5, voxel.position.z - 0.5 };
        cubeVertices[iota++] = { voxel.position.x - 0.5, voxel.position.y + 0.5, voxel.position.z - 0.5 };
       
        iota = 0;

        Vector3[36] cubeNormals;
        // Define the normals for each face
        // Front face
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        cubeNormals[iota++] = { 0.0, 0.0, -1.0 };
        // Define other faces similarly...

        iota = 0;

        // Copy data to arrays
        for (int j = 0; j < 36; j++) {
            vertices[vertexIndex * 3] = cubeVertices[j].x;
            vertices[vertexIndex * 3 + 1] = cubeVertices[j].y;
            vertices[vertexIndex * 3 + 2] = cubeVertices[j].z;

            normals[vertexIndex * 3] = cubeNormals[j].x;
            normals[vertexIndex * 3 + 1] = cubeNormals[j].y;
            normals[vertexIndex * 3 + 2] = cubeNormals[j].z;

            texcoords[vertexIndex * 2] = (j % 6 < 3) ? 0.0 : 1.0; // Example texcoords
            texcoords[vertexIndex * 2 + 1] = (j % 3 == 0) ? 0.0 : 1.0;

            colors[vertexIndex * 4] = voxel.color.r;
            colors[vertexIndex * 4 + 1] = voxel.color.g;
            colors[vertexIndex * 4 + 2] = voxel.color.b;
            colors[vertexIndex * 4 + 3] = voxel.color.a;

            vertexIndex++;
        }
    }

    Mesh mesh;
    mesh.vertexCount = verticesCount;
    mesh.triangleCount = verticesCount / 3;

    mesh.vertices = vertices;
    mesh.normals = normals;
    mesh.texcoords = texcoords;
    mesh.colors = colors;

    raylib::upload_mesh(&mesh, true);

    return mesh;
}
