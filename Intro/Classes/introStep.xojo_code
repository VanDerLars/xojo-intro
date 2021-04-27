#tag Class
Protected Class introStep
	#tag Method, Flags = &h21
		Private Sub addOuterContainer(parent as EmbeddedWindowControl, pos as introStepPosition)
		  pos.L = parent.Left + pos.L
		  pos.T = parent.Top + pos.T
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub addOuterContainer(parent as rectcontrol, pos as introStepPosition)
		  pos.L = parent.Left
		  pos.T = parent.Top
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub backgroundClicked(sender as introcnt)
		  Self.remove
		  
		  RaiseEvent callCancel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub cancelCalled(sender as introMessageMultiple)
		  Self.remove
		  
		  RaiseEvent callCancel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(focusControl_ as RectControl, title_ as string, message_ as String)
		  Self.focusControl = focusControl_
		  Self.title = title_
		  self.message = message_
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(focusWindow_ as window, title_ as string, message_ as String)
		  Self.focusWindow = focusWindow_
		  Self.title = title_
		  Self.message = message_
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub displayBackgroundRectControl()
		  // find position
		  Var pos As New introStepPosition(Self.focusControl)
		  Self.focusControlPosition = pos
		  
		  Var parent As Variant
		  
		  parent = focusControl.Parent
		  
		  If parent = Nil Then
		    // control is directly in a window
		    If focusWindow IsA ContainerControl Then
		      Var focCC As ContainerControl = ContainerControl(focusWindow)
		      myWindow = focCC.Window
		    Else
		      myWindow = focusControl.Window
		    End If
		  Else
		    // control is in a subcontrol
		    
		    While Not myWindow IsA Window
		      If Not parent IsA Window Then 
		        
		        // calc position
		        Var parentRect As RectControl 
		        Var parentContainer As EmbeddedWindowControl
		        
		        If parent IsA EmbeddedWindowControl Then
		          parentContainer = EmbeddedWindowControl(parent)
		          Self.addOuterContainer(parentContainer, pos)
		        Else
		          parentRect = RectControl(parent)
		          Self.addOuterContainer(parentRect, pos)
		        End If
		        
		        // check if its the base window
		        If parent IsA EmbeddedWindowControl Then
		          parent = parentContainer.Window
		        Else
		          parent = parentRect.Parent
		        End If
		        
		      Else
		        myWindow = parent
		      End If
		      
		    Wend
		  End If
		  
		  // embed containers
		  
		  Var cTop As New introCnt
		  Var cLeft As New introCnt
		  Var cBottom As New introCnt
		  Var cRight As New introCnt
		  
		  cTop.EmbedWithin(myWindow, 0, 0, myWindow.Width, pos.T)
		  cbottom.EmbedWithin(myWindow, 0, pos.T + pos.H, myWindow.Width, myWindow.Height - pos.T - pos.H)
		  cLeft.EmbedWithin(myWindow, 0, pos.T, pos.L, pos.H)
		  cRight.EmbedWithin(myWindow, pos.L + pos.W, pos.T, myWindow.Width - pos.L - pos.W, pos.H)
		  
		  Self.cntBottom = cBottom
		  Self.cntLeft = cLeft
		  Self.cntTop = cTop
		  Self.cntRight = cRight
		  
		  AddHandler cTop.clicked, AddressOf backgroundClicked
		  AddHandler cLeft.clicked, AddressOf backgroundClicked
		  AddHandler cBottom.clicked, AddressOf backgroundClicked
		  AddHandler cRight.clicked, AddressOf backgroundClicked
		  
		  // display message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub displayBackgroundWindowControl()
		  
		  If focusWindow IsA ContainerControl Then
		    // containercontrol
		    MessageBox("container")
		  Else
		    // window
		    Var cTop As New introCnt
		    cTop.EmbedWithin(focusWindow, 0, 0, focusWindow.Width, focusWindow.Width)
		    AddHandler cTop.clicked, AddressOf backgroundClicked
		    
		    Self.cntTop = cTop
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub displayIntroMessage()
		  If myWindow Is Nil And focusWindow <> Nil Then
		    // is a window or containercontrol
		    If focusWindow IsA ContainerControl Then
		      MessageBox("container")
		      
		    Else
		      // window
		      Var L, T As Integer
		      L = (focusWindow.Width / 2) - (Self.introMessageContainer.Width / 2)
		      T = (focusWindow.Height / 2) - (Self.introMessageContainer.Height / 2)
		      
		      Self.introMessageContainer.EmbedWithin(focusWindow, L, T, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		      
		    End If
		    
		  Else
		    Var pos As introStepPosition = Self.focusControlPosition
		    
		    Var gapToBottom As Integer = myWindow.Height - pos.T - pos.H + 5
		    
		    If gapToBottom > Self.introMessageContainer.Height Then
		      // embed below
		      Self.introMessageContainer.EmbedWithin(myWindow, pos.L, pos.T + pos.H + 5, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		    Else
		      
		      Var gapToTop As Integer =  pos.T - 5
		      
		      If gapToTop > Self.introMessageContainer.Height Then
		        // embed above
		        Self.introMessageContainer.EmbedWithin(myWindow, pos.L, pos.T - Self.introMessageContainer.Height - 5, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		      Else
		        Var gap_right As Integer = myWindow.Width - pos.L - pos.W -5
		        
		        If gap_right > Self.introMessageContainer.Width Then
		          // embed right
		          Self.introMessageContainer.EmbedWithin(myWindow, pos.L + pos.W + 5, pos.T, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		          
		        Else
		          Var gap_left As Integer = pos.L - 5
		          If gap_left > Self.introMessageContainer.Width Then
		            // embed left
		            Self.introMessageContainer.EmbedWithin(myWindow, pos.L - 5 - Self.introMessageContainer.Width, pos.T, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		            
		          Else
		            // cannot embed
		            // Display a modal dialog
		            Var m As New MessageDialog
		            m.Message = Self.title + EndOfLine + Self.message
		            If Not Self.isLastStep Then
		              m.IconType = MessageDialog.IconTypes.Note
		              m.ActionButton.Caption = "Next"
		            End If
		            If Not Self.isFirstStep Then
		              m.AlternateActionButton.Visible = True
		              m.AlternateActionButton.Caption = "Previous"
		            End If
		            
		            m.CancelButton.Visible = True
		            If Self.isLastStep Then
		              m.CancelButton.Caption = "Finish"
		            Else
		              m.CancelButton.Caption = "Cancel"
		            End If
		            
		            
		            Var erg As MessageDialogButton = m.showmodal
		            Select Case erg
		            Case m.ActionButton
		              // next
		              RaiseEvent callNextStep
		            Case m.AlternateActionButton
		              // prev
		              RaiseEvent callPrevStep
		            Case m.CancelButton
		              RaiseEvent callCancel
		            End Select
		            
		            Self.remove
		          End If
		          
		          
		        End If
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub nextCalled(sender as introMessage)
		  RaiseEvent CallNextStep
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub prevCalled(sender as introMessage)
		  
		  RaiseEvent CallPrevStep
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub remove()
		  
		  Var shouldClose As Boolean = False
		  
		  
		  If Self.cntTop <> Nil Then
		    shouldClose = True
		    Self.cntTop.Close
		  End If
		  
		  If Self.cntBottom <> Nil Then
		    shouldClose = True
		    Self.cntBottom.Close
		  End If
		  
		  If Self.cntLeft <> Nil Then
		    shouldClose = True
		    Self.cntLeft.Close
		  End If
		  
		  If Self.cntRight <> Nil Then
		    shouldClose = True
		    Self.cntRight.Close
		  End If
		  
		  
		  If shouldClose Then
		    Self.introMessageContainer.Close
		  End If
		  
		  Self.cntBottom = Nil
		  Self.cntTop = Nil
		  Self.cntLeft = Nil
		  Self.cntRight = Nil
		  
		  Self.introMessageContainer = Nil
		  
		  Self.myWindow = Nil
		  
		  RaiseEvent callCancel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub show()
		  If focusWindow <> Nil Then
		    If focusWindow IsA ContainerControl Then
		      Var r As New RectControl
		      r.Left = focusWindow.Left
		      r.Top = focusWindow.Top
		      r.Width = focusWindow.Width
		      r.Height = focusWindow.Height
		      
		      Self.focusControl = r
		      
		      Self.displayBackgroundRectControl
		    Else
		      Self.displayBackgroundWindowControl
		    End If
		  Else
		    Self.displayBackgroundRectControl
		  End If
		  
		  // multiple step UI
		  
		  Var mes As New introMessageMultiple
		  mes.title = Self.title
		  mes.message = Self.message
		  
		  Self.introMessageContainer = mes
		  mes.btn_next.Enabled = Not(Self.isLastStep)
		  mes.btn_prev.Enabled = Not(Self.isFirstStep)
		  
		  If Self.isLastStep Then 
		    mes.btn_cancel.Caption = "Finish"
		    mes.btn_cancel.Default = True
		  Else
		    mes.btn_cancel.Caption = "Cancel"
		    mes.btn_cancel.Default = False
		  End If
		  
		  AddHandler mes.callCancel, AddressOf cancelCalled
		  AddHandler mes.callprev, AddressOf prevCalled
		  AddHandler mes.callnext, AddressOf nextCalled
		  
		  
		  Self.displayIntroMessage
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub showSingle()
		  If Self.focusControl <> Nil Then Self.displayBackgroundRectControl
		  If Self.focusWindow <> Nil Then Self.displayBackgroundWindowControl
		  
		  // single UI
		  
		  Var mes As New introMessageSingle
		  mes.title = Self.title
		  mes.message = Self.message
		  
		  Self.introMessageContainer = mes
		  
		  
		  self.displayIntroMessage
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event callCancel()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event callNextStep()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event callPrevStep()
	#tag EndHook


	#tag Property, Flags = &h0
		cntBottom As introCnt
	#tag EndProperty

	#tag Property, Flags = &h0
		cntLeft As introCnt
	#tag EndProperty

	#tag Property, Flags = &h0
		cntRight As introCnt
	#tag EndProperty

	#tag Property, Flags = &h0
		cntTop As introCnt
	#tag EndProperty

	#tag Property, Flags = &h0
		focusControl As RectControl
	#tag EndProperty

	#tag Property, Flags = &h21
		Private focusControlPosition As introStepPosition
	#tag EndProperty

	#tag Property, Flags = &h0
		focusWindow As Window
	#tag EndProperty

	#tag Property, Flags = &h0
		introMessageContainer As introMessage
	#tag EndProperty

	#tag Property, Flags = &h0
		isFirstStep As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		isLastStep As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		message As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private myWindow As Window
	#tag EndProperty

	#tag Property, Flags = &h0
		title As string
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
		#tag ViewProperty
			Name="title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="message"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
