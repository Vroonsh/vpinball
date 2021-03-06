#pragma once

FILE* WaveFrontObj_ExportStart(const string& filename);
void WaveFrontObj_ExportEnd(FILE *f);
void WaveFrontObj_UpdateFaceOffset(unsigned int numVertices);
void WaveFrontObj_WriteObjectName(FILE *f, const string& objname);
void WaveFrontObj_WriteVertexInfo(FILE *f, const Vertex3D_NoTex2 *verts, unsigned int numVerts);
void WaveFrontObj_WriteFaceInfo(FILE *f, const std::vector<WORD> &faces);
void WaveFrontObj_WriteFaceInfoLong(FILE *f, const std::vector<unsigned int> &faces);
void WaveFrontObj_Save(const string& filename, const string& description, const Mesh& mesh);
void WaveFrontObj_GetVertices(std::vector<Vertex3D_NoTex2>& vertices);
void WaveFrontObj_GetIndices(std::vector<unsigned int>& idx);
bool WaveFrontObj_Load(const string& filename, const bool flipTv, const bool convertToLeftHanded);
void WaveFrontObj_WriteFaceInfoList(FILE *f, const WORD *faces, const unsigned int numIndices);
void WaveFrontObj_WriteMaterial(const string& texelName, const string& texelFilename, const Material * const mat);
void WaveFrontObj_UseTexture(FILE *f, const string& texelName);
bool WaveFrontObj_LoadMaterial(const string& filename, Material * const mat);
