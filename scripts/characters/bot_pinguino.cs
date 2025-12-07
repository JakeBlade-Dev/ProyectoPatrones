using Godot;
using System;

public partial class bot_pinguino : CharacterBody2D
{
	[Export] public float Speed = 80f;
	[Export] public float CheckInterval = 0.2f;
	[Export] public float MinMovement = 2.0f;

	private Vector2[] _directions =
	{
		Vector2.Right,
		Vector2.Down,
		Vector2.Left,
		Vector2.Up
	};

	private string[] _anims =
	{
		"walk_right",
		"walk_down",
		"walk_left",
        "walk_up"
	};

	private int _currentIndex = 0;

	private float _stuckCheckTimer = 0f;
	private Vector2 _lastCheckedPosition = Vector2.Zero;

	private AnimatedSprite2D _sprite;


	public override void _Ready()
	{
		_sprite = GetNode<AnimatedSprite2D>("Animacion_Pinguino");

		_lastCheckedPosition = Position;
		SetDirection(_currentIndex);
	}

	public override void _PhysicsProcess(double delta)
	{
		Velocity = _directions[_currentIndex] * Speed;
		MoveAndSlide();

		// Timer de verificación de movimiento
		_stuckCheckTimer += (float)delta;
		if (_stuckCheckTimer >= CheckInterval)
		{
			CheckIfStuck();
			_stuckCheckTimer = 0f;
		}
	}

	private void CheckIfStuck()
	{
		if (Position.DistanceTo(_lastCheckedPosition) < MinMovement)
		{
			ChangeDirectionRandom();
		}

		_lastCheckedPosition = Position;
	}

	private void ChangeDirectionRandom()
	{
		int oldIndex = _currentIndex;

		RandomNumberGenerator rng = new();
		rng.Randomize();

		while (_currentIndex == oldIndex && _directions.Length > 1)
		{
			_currentIndex = rng.RandiRange(0, _directions.Length - 1);
		}

		SetDirection(_currentIndex);
	}

	private void SetDirection(int idx)
	{
		_sprite.Animation = _anims[idx];
		_sprite.Play();
	}
}
