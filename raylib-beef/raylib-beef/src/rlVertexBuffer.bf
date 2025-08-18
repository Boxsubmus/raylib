using System;
using System.Interop;

namespace RaylibBeef;

[CRepr]
public struct rlVertexBuffer
{
	/// Number of elements in the buffer (QUADS)
	public int32 elementCount;
	
	/// Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
	public void* vertices;
	
	/// Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
	public void* texcoords;
	
	/// Vertex normal (XYZ - 3 components per vertex) (shader-location = 2)
	public void* normals;
	
	/// Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
	public void* colors;
	
	/// OpenGL Vertex Array Object id
	public void* vaoId;
	
	/// Vertex indices (in case vertex data comes indexed) (6 indices per quad)
	public void* indices;
	
	/// 
	public void* rlVertexBuffer;
	
	/// OpenGL Vertex Buffer Objects id (5 types of vertex data)
	public int32[5] vboId;
	
	public this(int32 elementCount, void* vertices, void* texcoords, void* normals, void* colors, void* vaoId, void* indices, void* rlVertexBuffer, int32[5] vboId)
	{
		this.elementCount = elementCount;
		this.vertices = vertices;
		this.texcoords = texcoords;
		this.normals = normals;
		this.colors = colors;
		this.vaoId = vaoId;
		this.indices = indices;
		this.rlVertexBuffer = rlVertexBuffer;
		this.vboId = vboId;
	}
}
