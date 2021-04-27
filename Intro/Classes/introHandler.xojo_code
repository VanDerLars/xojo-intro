#tag Class
Protected Class introHandler
	#tag Method, Flags = &h0
		Sub addStep(newStep as introStep)
		  self.introItems.Add(newStep)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub cancelCalled(sender as introStep)
		  
		  RemoveHandler sender.CallNextStep, AddressOf nextStepCalled
		  RemoveHandler sender.CallPrevStep, AddressOf prevStepCalled
		  RemoveHandler sender.callCancel, AddressOf cancelCalled
		  
		  Self.stop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub nextStep()
		  Var nextstepIndex As Integer = Self.currStepIndex + 1
		  
		  If nextstepIndex > Self.introItems.LastIndex Then 
		    Exit Sub
		  Else
		    showStep(nextstepIndex)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub nextStepCalled(sender as introStep)
		  self.nextStep
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub prevStep()
		  Var nextstepIndex As Integer = Self.currStepIndex - 1
		  
		  If nextstepIndex = -1 Then 
		    Exit Sub
		  Else
		    showStep(nextstepIndex)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub prevStepCalled(sender as introStep)
		  self.prevStep
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeCurrentStep()
		  Self.currStep.remove
		  Self.currStep = Nil
		  
		  Self.currStepIndex = -1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub showStep(ind as integer)
		  If Self.currStep <> Nil Then
		    Self.removeCurrentStep
		  End If
		  
		  Var nextstep As introStep = Self.introItems(ind)
		  
		  AddHandler nextstep.CallNextStep, AddressOf nextStepCalled
		  AddHandler nextstep.CallPrevStep, AddressOf prevStepCalled
		  AddHandler nextstep.callCancel, AddressOf cancelCalled
		  
		  
		  Self.currStep = nextstep
		  Self.currStepIndex = ind
		  
		  nextstep.isLastStep = (Self.introItems.LastIndex = ind)
		  nextstep.isFirstStep = (ind = 0)
		  
		  nextstep.show
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub start()
		  self.showStep(0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub stop()
		  self.removeCurrentStep
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private currStep As introStep
	#tag EndProperty

	#tag Property, Flags = &h21
		Private currStepIndex As integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		introItems() As introStep
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
