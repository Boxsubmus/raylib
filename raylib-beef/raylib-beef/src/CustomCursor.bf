using System;
using System.Interop;

namespace RaylibBeef;

[CRepr]
public struct CustomCursor
{
	/// 
	public void* cursorObj;
	
	public this(void* cursorObj)
	{
		this.cursorObj = cursorObj;
	}
}
