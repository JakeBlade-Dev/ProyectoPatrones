using Godot;
using System;

public partial class caballero : CharacterBody2D
{
	private bool _playerInRange = false;
	private Node2D _playerReference = null;
	private Node2D _speechBubble = null;

	public override void _Ready()
	{
		GD.Print("=== INICIANDO CABALLERO ===");
		SetupInteractionArea();
		CreateSpeechBubble();
	}

	private void SetupInteractionArea()
	{
		// Crear Area2D
		var area = new Area2D
		{
			Name = "InteractionArea"
		};
		AddChild(area);

		// Crear CollisionShape2D
		var collision = new CollisionShape2D();
		var shape = new CircleShape2D
		{
			Radius = 50
		};
		collision.Shape = shape;
		area.AddChild(collision);

		// Conectar señales
		area.BodyEntered += OnBodyEntered;
		area.BodyExited += OnBodyExited;
	}

	private void CreateSpeechBubble()
	{
		_speechBubble = new Node2D
		{
			Name = "SpeechBubble",
			Position = new Vector2(0, -60),
			Visible = false,
			ZIndex = 100
		};
		AddChild(_speechBubble);

		var label = new Label
		{
			Name = "Text",
			Text = "Presiona E para\niniciar la trivia",

			OffsetLeft = -60,
			OffsetTop = -25,
			OffsetRight = 60,
			OffsetBottom = 25,

			HorizontalAlignment = HorizontalAlignment.Center,
			VerticalAlignment = VerticalAlignment.Center
		};

		label.AddThemeColorOverride("font_color", Colors.Black);
		label.AddThemeFontSizeOverride("font_size", 12);

		var styleBox = new StyleBoxFlat
		{
			BgColor = new Color(1, 1, 1, 0.95f),
			BorderColor = new Color(0, 0, 0, 0.8f),
			BorderWidthLeft = 2,
			BorderWidthRight = 2,
			BorderWidthTop = 2,
			BorderWidthBottom = 2,
			CornerRadiusTopLeft = 8,
			CornerRadiusTopRight = 8,
			CornerRadiusBottomLeft = 8,
			CornerRadiusBottomRight = 8
		};

		label.AddThemeStyleboxOverride("normal", styleBox);

		_speechBubble.AddChild(label);
	}

	private void OnBodyEntered(Node body)
	{
		if (body.Name == "Mono" || body.Name == "PJ_Principal")
		{
			GD.Print("✅ Jugador cerca del caballero");

			_playerInRange = true;
			_playerReference = (Node2D)body;
			_speechBubble.Visible = true;
		}
	}

	private void OnBodyExited(Node body)
	{
		if (body.Name == "Mono" || body.Name == "PJ_Principal")
		{
			GD.Print("❌ Jugador se alejó del caballero");

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
				GD.Print("✅ Posición del jugador guardada (caballero): ", Global.posicion_mono);
			}
			else
			{
				GD.Print("⚠️ No hay referencia del jugador disponible");
			}

			GetTree().ChangeSceneToFile("res://scenes/ui/trivia.tscn");
		}
	}
}
