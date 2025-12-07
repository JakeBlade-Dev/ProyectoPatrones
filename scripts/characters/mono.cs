using Godot;
using System;

public partial class mono : CharacterBody2D
{
	private bool _canMove = true;

	public override void _Ready()
	{
		Name = "Mono";
		GD.Print("=== MONO INICIALIZADO ===");
		GD.Print("Nombre del nodo: ", Name);

		// Crear pivot parent
		var pivotParent = new Node2D
		{
			Name = "PivotParent"
		};
		AddChild(pivotParent);

		// Restaurar posición desde Global
		if (Global.posicion_mono != Vector2.Zero)
		{
			GD.Print("Posición Mono actualizada: ", Global.posicion_mono);
			GlobalPosition = Global.posicion_mono;
		}

		// Offset del pivot
		pivotParent.Position = new Vector2(0, -40);

		// Mover nodo "animaciones" al pivot
		var animacionesNode = GetNode<AnimatedSprite2D>("animaciones");
		RemoveChild(animacionesNode);
		pivotParent.AddChild(animacionesNode);
		animacionesNode.Owner = pivotParent;

		// Reproducir animación
		animacionesNode.Play("XD");
	}

	public override void _PhysicsProcess(double delta)
	{
		if (!_canMove)
		{
			Velocity = Vector2.Zero;
			MoveAndSlide();
			return;
		}

		Vector2 dir = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		Velocity = dir * 200;
		MoveAndSlide();
	}

	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventKey keyEvent && keyEvent.Pressed)
		{
			GD.Print($"MONO - Tecla presionada: {keyEvent.Keycode}");

			if (keyEvent.Keycode == Key.E)
				GD.Print("MONO - ¡Tecla E detectada!");

			if (keyEvent.Keycode == Key.Enter)
				GD.Print("MONO - ¡Tecla ENTER detectada!");
		}
	}

	public void DisableMovement()
	{
		_canMove = false;
		GD.Print("MONO - Movimiento desactivado");
	}

	public void EnableMovement()
	{
		_canMove = true;
		GD.Print("MONO - Movimiento activado");
	}
}
