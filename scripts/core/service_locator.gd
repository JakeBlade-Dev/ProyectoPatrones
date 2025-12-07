# ============================================================================
# SERVICE LOCATOR
# ============================================================================
# Implementa IoC mediante Service Locator pattern
#
# DESIGN PATTERNS APPLIED:
# ------------------------
# [Service Locator] PatrÃ³n de DiseÃ±o ArquitectÃ³nico
#       Proporciona un registro global para servicios de la aplicaciÃ³n
#
# [Dependency Injection] Principio de DiseÃ±o
#       Invierte el control: los servicios se inyectan, no se crean directamente
#
# SOLID PRINCIPLES:
# -----------------
# [DIP] Dependency Inversion - Depender de abstracciones, no de concreciones
# [SRP] Single Responsibility - Solo gestiona el registro de servicios
#
# Benefits:
# - Desacoplamiento entre componentes
# - Facilita testing con servicios mock
# - ConfiguraciÃ³n centralizada de dependencias
# ============================================================================

class_name ServiceLocator
extends Node

## Registro de servicios (singleton)
static var _services: Dictionary = {}

## Registra un servicio
## @param service_name: Nombre identificador del servicio
## @param service_instance: Instancia del servicio
static func register_service(service_name: String, service_instance) -> void:
    if _services.has(service_name):
        push_warning("Servicio ya registrado, se reemplazarÃ¡: " + service_name)
    
    _services[service_name] = service_instance
    print("âœ… Servicio registrado: " + service_name)

## Obtiene un servicio del registro
## @param service_name: Nombre del servicio a obtener
## @returns: Instancia del servicio o null si no existe
static func get_service(service_name: String):
    if not _services.has(service_name):
        push_error("Servicio no encontrado: " + service_name)
        return null
    
    return _services[service_name]

## Elimina un servicio del registro
static func unregister_service(service_name: String) -> void:
    if _services.has(service_name):
        _services.erase(service_name)
        print(" Servicio desregistrado: " + service_name)

## Limpia todos los servicios
static func clear_all() -> void:
    _services.clear()
    print("âœ… Todos los servicios limpiados")

## Verifica si un servicio estÃ¡ registrado
static func has_service(service_name: String) -> bool:
    return _services.has(service_name)