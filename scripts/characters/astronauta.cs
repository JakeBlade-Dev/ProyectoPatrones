using Godot;
using System;

public partial class astronauta : CharacterBody2D
{
	private bool _playerInRange = false;
	private Node2D _playerReference = null;
	private Node2D _speechBubble = null;

	public override void _Ready()
	{
		GD.Print("=== INICIANDO ASTRONAUTA ===");
		SetupInteractionArea();
		CreateSpeechBubble();
	}

	private void SetupInteractionArea()
	{
		var area = new Area2D
		{
			Name = "InteractionArea"
		};
		AddChild(area);

		var collision = new CollisionShape2D();
		var shape = new CircleShape2D
		{
			Radius = 50
		};
		collision.Shape = shape;
		area.AddChild(collision);

		area.BodyEntered += OnBodyEntered;
		area.BodyExited += OnBodyExited;

		GD.Print("✅ Área de interacción del astronauta configurada");
	}

	private void CreateSpeechBubble()
	{
		_speechBubble = new Node2D
		{
			Name = "SpeechBubble",
			Position = new Vector2(0, -90),
			Visible = false,
			ZIndex = 100
		};
		AddChild(_speechBubble);

		var label = new Label
		{
			Name = "Text",
			Text = "Presiona E para jugar\nSpace Invaders",
			HorizontalAlignment = HorizontalAlignment.Center,
			VerticalAlignment = VerticalAlignment.Center,
			OffsetLeft = -70,
			OffsetTop = -25,
			OffsetRight = 70,
			OffsetBottom = 25
		};

		// Estilos
		var style = new StyleBoxFlat
		{
			BgColor = new Color(0.1f, 0.1f, 0.2f, 0.95f),
			BorderColor = new Color(0.3f, 0.6f, 1.0f, 0.9f),
			CornerRadiusTopLeft = 10,
			CornerRadiusTopRight = 10,
			CornerRadiusBottomLeft = 10,
			CornerRadiusBottomRight = 10
		};
		style.BorderWidthLeft = 3;
		style.BorderWidthRight = 3;
		style.BorderWidthTop = 3;
		style.BorderWidthBottom = 3;

		label.AddThemeStyleboxOverride("normal", style);
		label.AddThemeColorOverride("font_color", new Color(0.7f, 0.9f, 1.0f));
		label.AddThemeFontSizeOverride("font_size", 11);

		_speechBubble.AddChild(label);
	}

	private void OnBodyEntered(Node body)
	{
		if (body.Name == "Mono" || body.Name == "PJ_Principal")
		{
			GD.Print("✅ Jugador cerca del astronauta");
			_playerInRange = true;
			_playerReference = body as Node2D;
			_speechBubble.Visible = true;
		}
	}

	private void OnBodyExited(Node body)
	{
		if (body.Name == "Mono" || body.Name == "PJ_Principal")
		{
			GD.Print("❌ Jugador se alejó del astronauta");
			_playerInRange = false;
			_playerReference = null;
			_speechBubble.Visible = false;
		}
	}

	public override void _Process(double delta)
	{
		if (_playerInRange && (Input.IsActionJustPressed("ui_accept") || Input.IsKeyPressed(Key.E)))
		{
			_speechBubble.Visible = false;

			if (_playerReference != null)
			{
				Global.posicion_mono = _playerReference.GlobalPosition;
				GD.Print("✅ Posición del jugador guardada (astronauta): ", Global.posicion_mono);
			}

			GetTree().ChangeSceneToFile("res://spaceship/scenes/MainMenu.tscn");
		}
	}
}
