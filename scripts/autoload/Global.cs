// ============================================================================
// GLOBAL AUTOLOAD (C# Version)
// ============================================================================
// Singleton global accesible desde scripts C#
//
// SOLID PRINCIPLES APPLIED:
// -------------------------
// [SRP] Single Responsibility Principle (Principio de Responsabilidad Única)
//       Responsabilidad única: Mantener estado global compartido entre escenas.
//       No maneja lógica de juego compleja, solo almacena datos persistentes.
//
// Design Pattern: Singleton (mediante Autoload de Godot)
//       Garantiza una única instancia accesible globalmente desde C#.
//
// Benefits:
// - Interoperabilidad entre scripts GDScript y C#
// - Estado persistente entre cambios de escena
// - Punto de acceso global para datos compartidos
//
// Usage:
//   Global.posicion_mono = player.GlobalPosition;
//   var savedPos = Global.posicion_mono;
// ============================================================================

using Godot;
using System;

/// <summary>
/// Singleton global que mantiene estado compartido entre escenas
/// Accesible desde scripts C# mediante la clase estática Global
/// </summary>
public partial class Global : Node
{
    // ========================================================================
    // STATIC FIELDS (Estado global compartido)
    // ========================================================================
    
    /// <summary>
    /// Posición guardada del jugador principal (Mono o PJ_Principal)
    /// Usada para restaurar posición al regresar del mundo principal
    /// </summary>
    public static Vector2 posicion_mono = Vector2.Zero;

    // ========================================================================
    // LIFECYCLE METHODS
    // ========================================================================
    
    public override void _Ready()
    {
        // Inicialización si es necesaria
        GD.Print("Global (C#) inicializado");
    }
}