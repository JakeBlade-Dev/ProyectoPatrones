// ============================================================================
// NPC KNIGHT
// ============================================================================
// NPC que permite acceder al sistema de trivia
//
// SOLID PRINCIPLES APPLIED:
// -------------------------
// [LSP] Liskov Substitution Principle (Principio de Sustitución de Liskov)
//       Esta clase puede usarse en cualquier lugar que espere un NPC
//       interactuable sin romper la funcionalidad.
//
// [SRP] Single Responsibility Principle (Principio de Responsabilidad Única)
//       Responsabilidad única: Gestionar la interacción específica del
//       caballero (cambiar a escena de trivia).
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
// - Consistencia: Comportamiento uniforme entre todos los NPCs
// ============================================================================

using Godot;
using System;

/// <summary>
/// NPC Caballero que permite iniciar el sistema de trivia
/// </summary>
public partial class NpcKnight : CharacterBody2D
{
    // ========================================================================
    // CONSTANTS (Configuración del NPC)
    // ========================================================================
    
    /// <summary>Texto mostrado en el bocadillo de interacción</summary>
    private const string InteractionText = "Presiona E para\niniciar la trivia";
    
    /// <summary>Escena a la que se cambia al interactuar</summary>
    private const string TargetScene = "res://scenes/ui/trivia.tscn";
    
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
        GD.Print("=== INICIANDO CABALLERO ===");
        
        // Inicializar helper con configuración específica del caballero
        _npcHelper = new InteractableNPCHelper(this, "Caballero", InteractionText);
        
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
    /// Maneja la interacción con el caballero: cambia a escena de trivia
    /// Este método es llamado por el helper cuando el jugador presiona E
    /// </summary>
    private void HandleInteraction()
    {
        GetTree().ChangeSceneToFile(TargetScene);
    }
}