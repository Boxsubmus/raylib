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
	
	/// 
	public void* rlVertexBuffer;
	
	/// Vertex indices (in case vertex data comes indexed) (6 indices per quad)
	public void* indices;
	
	/// Matrix third row (4 components)
	public void* m2;
	
	/// Matrix third row (4 components)
	public void* m6;
	
	/// Matrix third row (4 components)
	public void* m10;
	
	/// Matrix third row (4 components)
	public void* m14;
	
	/// OpenGL Vertex Array Object id
	public void* vaoId;
	
	/// OpenGL Vertex Buffer Objects id (5 types of vertex data)
	public int32[5] vboId;
	
	public this(int32 elementCount, void* vertices, void* texcoords, void* normals, void* colors, void* rlVertexBuffer, void* indices, void* m2, void* m6, void* m10, void* m14, void* vaoId, int32[5] vboId)
	{
		this.elementCount = elementCount;
		this.vertices = vertices;
		this.texcoords = texcoords;
		this.normals = normals;
		this.colors = colors;
		this.rlVertexBuffer = rlVertexBuffer;
		this.indices = indices;
		this.m2 = m2;
		this.m6 = m6;
		this.m10 = m10;
		this.m14 = m14;
		this.vaoId = vaoId;
		this.vboId = vboId;
	}
}
