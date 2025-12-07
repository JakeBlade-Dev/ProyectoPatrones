using Godot;
using System;

public partial class menu : Control
{
	private Tween tweenBtnIniciar;
	private TextureButton btnIniciar;
	private TextureButton btnSalir;
	private AudioStreamPlayer2D audioMenu;

	private Vector2 posicionInicialBtn;

	public override void _Ready()
	{
		// Obtener nodos reales
		btnIniciar = GetNode<TextureButton>("BtnIniciar");
		btnSalir = GetNode<TextureButton>("BtnSalir");
		audioMenu = GetNode<AudioStreamPlayer2D>("AudioStreamPlayer2D");

		// Dar foco al botón iniciar
		GetNode<Button>("Iniciar").GrabFocus();

		// Configurar escala inicial del botón
		btnIniciar.Scale = new Vector2(0.3f, 0.3f);

		// Guardar posición inicial
		posicionInicialBtn = btnIniciar.Position;

		// Iniciar animación
		AnimarBotonIniciar();

		// Conectar señales
		btnIniciar.Pressed += OnBtnIniciarPressed;
		btnSalir.Pressed += OnBtnSalirPressed;
	}

	private void AnimarBotonIniciar()
	{
		tweenBtnIniciar = CreateTween();
		tweenBtnIniciar.SetLoops();
		tweenBtnIniciar.SetTrans(Tween.TransitionType.Sine);
		tweenBtnIniciar.SetEase(Tween.EaseType.InOut);

		Vector2 posArriba = new Vector2(posicionInicialBtn.X, posicionInicialBtn.Y - 6);
		Vector2 posAbajo = new Vector2(posicionInicialBtn.X, posicionInicialBtn.Y + 6);

		tweenBtnIniciar.TweenProperty(btnIniciar, "position", posArriba, 1.0);
		tweenBtnIniciar.TweenProperty(btnIniciar, "position", posAbajo, 1.0);
		tweenBtnIniciar.TweenProperty(btnIniciar, "position", posicionInicialBtn, 1.0);
	}

	private async void OnBtnIniciarPressed()
	{
		if (tweenBtnIniciar != null)
			tweenBtnIniciar.Kill();

		GD.Print("click");

		var tweenClick = CreateTween();
		Vector2 posPresionado = new Vector2(posicionInicialBtn.X, posicionInicialBtn.Y + 5);

		tweenClick.TweenProperty(btnIniciar, "position", posPresionado, 0.1);
		tweenClick.TweenProperty(btnIniciar, "position", posicionInicialBtn, 0.2);

		// Detener música
		audioMenu.Stop();

		// Esperar 0.5 segundos
		await ToSignal(GetTree().CreateTimer(0.5f), SceneTreeTimer.SignalName.Timeout);

		GetTree().ChangeSceneToFile("res://scenes/levels/mundo.tscn");
	}

	private void OnBtnSalirPressed()
	{
		GetTree().Quit();
	}
}
