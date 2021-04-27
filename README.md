## Xojo Intro

Xojo-Intro implements a simple way to build step-by-step tutorials in Xojo destop applications.

The equivalent for xojo web framework 1 is here -> https://github.com/VanDerLars/xojo_intro_js/

### Usage as multiple step intro

Multiple step intros provide a simple UI to step-by-step describe your controls and functionalities.

1. copy the folder "Intro" into your project
2. Drag the class Intro->Classes `IntroHandler` onto your Window
3. Add in the window `open` event your steps (code see below)
4. Call your intro with `Self.introHandler1.start`

SampleCode:
``` Xojo
Sub ShowMultipleIntro()
// you can use every regular Control (which inherits from RectControl)
Self.introHandler1.addStep(New introStep(Self.ComboBox1, "Combobox", "The combobox combines a textarea and a listbox"))
Self.introHandler1.addStep(New introStep(Self.GroupBox1, "Groupbox", "Groupboxes are used to group multiple controls"))
Self.introHandler1.addStep(New introStep(Self.PushButton1, "PushButton", "This is a button which fires some code."))

// you can also use a Window
Self.introHandler1.addStep(New introStep(Self, "Window", "Windows are the basic user interface structures where you can place your controls onto"))

// also embedded ContainerControls are possible
Self.introHandler1.addStep(New introStep(Self.TestContainer1, "ContainerControl", "ContainerControls are structures to be embedded into a layout. You can nest Controls."))

// and also controls inside embedded ContainerControls
Self.introHandler1.addStep(New introStep(Self.TestContainer1.Label2, "Nested Controls", "With this library you can even focus on controls which are placed inside Containers."))

Self.introHandler1.start
End Sub
```

### Usage as single

Single steps simply show your description next to your control.

``` Xojo
Sub ShowSingleStep()
  Var d As New introStep(GroupBox1, "hallo", "yay")
  d.showSingle
  
End Sub
```

See the test project, this should give you everthing you need.


## Good to know:

- You can control the colors of your intros by altering the background color properties of the controls under Intro->UI
- The IntroHandler will always try to display the IntoContainer in a good position next to the highlighted Control. In case that there's not enough space on your layout, it will display a `messagebox`
- You can use all sorts of regular UI controls, which inherit from `RectControl`, but also `Window` and `ContainerControl` is possible
- Controls inside nested ContainerControls will work as well

## Screenshot:
Basic functions:
![screencast](https://github.com/VanDerLars/xojo-intro/blob/main/screencast.gif)

Resizing (not perfect currently):

![screencast resize](https://github.com/VanDerLars/xojo-intro/blob/main/screencast_resize.gif)

## Ideas and todo

- [ ] Add ControlArrays to highlight more than one Control (currently only possible by using ContainerControls)
- ~~[ ] Make use of the AnimationKit to smoothen the things a bit~~ _Canceled, because animation kit has no transperancy animations._
- [ ] Find another way to animate some things.
- [ ] More configurations of the whole thing would be a good thing.
- [X] Resize the highlight area together with the window.
- [ ] Better resizing for some corner cases.

## Contribute

I don't plan to put much effort into this project. It was a fun little thing which I developed in three hours. But since I'm not really using Xojo desktop, I wouldn't make use of it in the future.

So feel free to pull the code, extend it and send your improvements in a PullRequest/MergeRequest. It's now up to you to make this basic thing better.
