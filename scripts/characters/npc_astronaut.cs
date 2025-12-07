// ============================================================================
// NPC ASTRONAUT
// ============================================================================
// NPC que permite acceder al minijuego Space Invaders
//
// SOLID PRINCIPLES APPLIED:
// -------------------------
// [LSP] Liskov Substitution Principle (Principio de Sustitución de Liskov)
//       Esta clase puede usarse en cualquier lugar que espere un NPC
//       interactuable sin romper la funcionalidad.
//
// [SRP] Single Responsibility Principle (Principio de Responsabilidad Única)
//       Responsabilidad única: Gestionar la interacción específica del
//       astronauta (cambiar a escena de Space Invaders).
//       Delega comportamiento común a InteractableNPCHelper.
//
// [DIP] Dependency Inversion Principle (Principio de Inversión de Dependencias)
//       Depende de abstracciones (InteractableNPCHelper) no de implementaciones
//       concretas. Usa callbacks (Action) para comportamiento personalizado.
//
// Benefits:
// - Reutiliza lógica común mediante composición (InteractableNPCHelper)
// - Fácil de modificar: cambiar escena destino o texto sin tocar lógica base
// - Mantenible: Mejoras en helper benefician a todos los NPCs
// ============================================================================

using Godot;
using System;

/// <summary>
/// NPC Astronauta que permite iniciar el minijuego Space Invaders
/// </summary>
public partial class NpcAstronaut : CharacterBody2D
{
    // ========================================================================
    // CONSTANTS (Configuración del NPC)
    // ========================================================================
    
    /// <summary>Texto mostrado en el bocadillo de interacción</summary>
    private const string InteractionText = "Presiona E para jugar\nSpace Invaders";
    
    /// <summary>Escena a la que se cambia al interactuar</summary>
    private const string TargetScene = "res://spaceship/scenes/MainMenu.tscn";
    
    // ========================================================================
    // PRIVATE FIELDS (SRP - Composición sobre herencia)
    // ========================================================================
    
    /// <summary>Helper que gestiona la lógica común de interacción</summary>
    private InteractableNPCHelper _npcHelper;

    // ========================================================================
    // LIFECYCLE METHODS
    // ========================================================================
    
    public override void _Ready()
    {
        GD.Print("=== INICIANDO ASTRONAUTA ===");
        
        // Inicializar helper con configuración específica del astronauta
        _npcHelper = new InteractableNPCHelper(this, "Astronauta", InteractionText);
        
        // Configurar estilo visual personalizado del bocadillo
        _npcHelper.SetBubbleStyle(
            new Color(0.1f, 0.1f, 0.2f, 0.95f),  // Fondo azul oscuro
            new Color(0.3f, 0.6f, 1.0f, 0.9f),   // Borde azul brillante
            new Color(0.7f, 0.9f, 1.0f)          // Texto azul claro
        );
        
        // Ajustar posición del bocadillo (más arriba que el default)
        _npcHelper.BubbleOffset = new Vector2(0, -90);
        
        // DIP: Inyectar comportamiento personalizado mediante callback
        _npcHelper.OnInteraction = HandleInteraction;
    }

    public override void _Process(double delta)
    {
        _npcHelper?.Update(delta);
    }

    // ========================================================================
    // INTERACTION HANDLER (Comportamiento específico)
    // ========================================================================
    
    /// <summary>
    /// Maneja la interacción con el astronauta: cambia a escena Space Invaders
    /// Este método es llamado por el helper cuando el jugador presiona E
    /// </summary>
    private void HandleInteraction()
    {
        GetTree().ChangeSceneToFile(TargetScene);
    }
}

// ============================================================================
// INTERACTABLE NPC HELPER (Clase auxiliar reutilizable)
// ============================================================================
// Helper class que implementa la lógica común de interacción para NPCs
//
// SOLID PRINCIPLES APPLIED:
// -------------------------
// [SRP] Single Responsibility Principle (Principio de Responsabilidad Única)
//       Responsabilidad única: Gestionar interacción básica jugador-NPC.
//       No conoce lógica específica de cada NPC (usa callbacks).
//
// [OCP] Open/Closed Principle (Principio Abierto/Cerrado)
//       Abierto para extensión mediante propiedades configurables y callbacks.
//       Cerrado para modificación: no necesita cambios para soportar nuevos NPCs.
//
// [DIP] Dependency Inversion Principle (Principio de Inversión de Dependencias)
//       Usa System.Action (callback) para delegar comportamiento específico,
//       evitando dependencias hacia clases concretas de NPCs.
//
// Benefits:
// - Elimina duplicación de código entre NPCs
// - Facilita testing: puede probarse independientemente
// - Configuración flexible mediante propiedades públicas
// ============================================================================

/// <summary>
/// Helper que proporciona funcionalidad común de interacción para NPCs
/// Implementa composición sobre herencia (más flexible que herencia en C#)
/// </summary>
public class InteractableNPCHelper
{
    // ========================================================================
    // PRIVATE FIELDS (Estado interno encapsulado)
    // ========================================================================
    
    private CharacterBody2D _owner;
    private bool _playerInRange = false;
    private Node2D _playerReference = null;
    private Node2D _speechBubble = null;
    private string _npcName;
    private string _interactionText;
    
    // ========================================================================
    // PUBLIC PROPERTIES (Configuración expuesta)
    // ========================================================================
    
    /// <summary>Desplazamiento del bocadillo respecto al NPC</summary>
    public Vector2 BubbleOffset { get; set; } = new Vector2(0, -60);
    
    /// <summary>
    /// Callback ejecutado cuando el jugador interactúa
    /// DIP: Inversión de dependencia mediante delegate
    /// </summary>
    public System.Action OnInteraction { get; set; }
    
    // ========================================================================
    // CONSTRUCTOR
    // ========================================================================
    
    /// <summary>
    /// Crea una nueva instancia del helper
    /// </summary>
    /// <param name="owner">CharacterBody2D propietario (el NPC)</param>
    /// <param name="npcName">Nombre identificador del NPC</param>
    /// <param name="interactionText">Texto del bocadillo de interacción</param>
    public InteractableNPCHelper(CharacterBody2D owner, string npcName, string interactionText)
    {
        _owner = owner;
        _npcName = npcName;
        _interactionText = interactionText;
        SetupInteractionArea();
        CreateSpeechBubble();
    }

    // ========================================================================
    // SETUP METHODS (Inicialización)
    // ========================================================================
    
    /// <summary>Configura el área de detección de proximidad</summary>
    private void SetupInteractionArea()
    {
        var area = new Area2D { Name = "InteractionArea" };
        _owner.AddChild(area);

        var collision = new CollisionShape2D();
        var shape = new CircleShape2D { Radius = 50 };
        collision.Shape = shape;
        area.AddChild(collision);

        // Conectar eventos de entrada/salida
        area.BodyEntered += OnBodyEntered;
        area.BodyExited += OnBodyExited;

        GD.Print($" Área de interacción de {_npcName} configurada");
    }

    /// <summary>Crea el bocadillo de diálogo visual</summary>
    private void CreateSpeechBubble()
    {
        _speechBubble = new Node2D
        {
            Name = "SpeechBubble",
            Position = BubbleOffset,
            Visible = false,
            ZIndex = 100
        };
        _owner.AddChild(_speechBubble);

        var label = new Label
        {
            Name = "Text",
            Text = _interactionText,
            HorizontalAlignment = HorizontalAlignment.Center,
            VerticalAlignment = VerticalAlignment.Center,
            OffsetLeft = -70,
            OffsetTop = -25,
            OffsetRight = 70,
            OffsetBottom = 25
        };

        SetDefaultLabelStyle(label);
        _speechBubble.AddChild(label);
    }

    // ========================================================================
    // STYLING METHODS (Configuración visual)
    // ========================================================================
    
    /// <summary>
    /// Configura colores personalizados del bocadillo
    /// OCP: Permite customización sin modificar código del helper
    /// </summary>
    public void SetBubbleStyle(Color bgColor, Color borderColor, Color fontColor)
    {
        if (_speechBubble == null) return;
        
        var label = _speechBubble.GetNode<Label>("Text");
        var style = new StyleBoxFlat
        {
            BgColor = bgColor,
            BorderColor = borderColor,
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
        label.AddThemeColorOverride("font_color", fontColor);
    }

    /// <summary>Aplica el estilo por defecto al label</summary>
    private void SetDefaultLabelStyle(Label label)
    {
        var style = new StyleBoxFlat
        {
            BgColor = new Color(1, 1, 1, 0.95f),
            BorderColor = new Color(0, 0, 0, 0.8f),
            CornerRadiusTopLeft = 8,
            CornerRadiusTopRight = 8,
            CornerRadiusBottomLeft = 8,
            CornerRadiusBottomRight = 8
        };
        style.BorderWidthLeft = 2;
        style.BorderWidthRight = 2;
        style.BorderWidthTop = 2;
        style.BorderWidthBottom = 2;

        label.AddThemeStyleboxOverride("normal", style);
        label.AddThemeColorOverride("font_color", Colors.Black);
        label.AddThemeFontSizeOverride("font_size", 11);
    }

    // ========================================================================
    // EVENT HANDLERS (Manejo de eventos)
    // ========================================================================
    
    private void OnBodyEntered(Node body)
    {
        if (IsPlayer(body))
        {
            GD.Print($" Jugador cerca de {_npcName}");
            _playerInRange = true;
            _playerReference = body as Node2D;
            _speechBubble.Visible = true;
        }
    }

    private void OnBodyExited(Node body)
    {
        if (IsPlayer(body))
        {
            GD.Print($" Jugador se alejó de {_npcName}");
            _playerInRange = false;
            _playerReference = null;
            _speechBubble.Visible = false;
        }
    }

    // ========================================================================
    // UTILITY METHODS
    // ========================================================================
    
    private bool IsPlayer(Node body)
    {
        return body.Name == "Mono" || body.Name == "PJ_Principal";
    }

    /// <summary>
    /// Actualiza el estado del helper (llamar desde _Process del owner)
    /// Verifica input de interacción y ejecuta callback si corresponde
    /// </summary>
    public void Update(double delta)
    {
        if (_playerInRange && (Input.IsActionJustPressed("ui_accept") || Input.IsKeyPressed(Key.E)))
        {
            _speechBubble.Visible = false;

            // Guardar posición del jugador en sistema global
            if (_playerReference != null)
            {
                Global.posicion_mono = _playerReference.GlobalPosition;
                GD.Print($" Posición guardada ({_npcName}): ", Global.posicion_mono);
            }

            // DIP: Ejecutar callback inyectado (no conocemos implementación específica)
            OnInteraction?.Invoke();
        }
    }
}