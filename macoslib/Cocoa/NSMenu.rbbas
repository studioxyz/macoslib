#tag Class
Class NSMenu
Inherits NSObject
	#tag Method, Flags = &h1000
		Sub Constructor(title as String = "")
		  #if targetCocoa
		    declare function initWithTitle lib CocoaLib selector "initWithTitle:" (obj_id as Ptr, title as CFStringRef) as Ptr
		    
		    dim menuRef as Ptr = initWithTitle(Allocate("NSMenu"), title)
		    self.Constructor(menuRef, NSObject.hasOwnership)
		    
		  #else
		    #pragma unused title
		  #endif
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Description"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="NSObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass