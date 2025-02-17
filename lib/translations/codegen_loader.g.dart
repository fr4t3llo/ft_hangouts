// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "contact": "Contact",
  "add_contact": "Add Contact",
  "edit_contact": "Edit Contact",
  "first_name": "First name",
  "last_name": "Last name",
  "phone_number": "Phone Number",
  "email": "Email",
  "permission_denied": "Permission denied to access contacts",
  "retry": "Retry",
  "request_permission": "Request Permission",
  "please_grant_permission": "Please grant permission to access contacts in your device settings.",
  "contact_added_successfully": "Contact added successfully",
  "error_adding_contact": "Error adding contact: ",
  "error_accessing_contacts": "Error accessing contacts: ",
  "permission_denied_contacts": "Permission denied",
  "error": "Error",
  "could_not_open_messages_app": "Could not open Messages app",
  "ok": "OK",
  "error_opening_messages": "Error opening Messages: ",
  "could_not_open_phone_app": "Could not open Phone app",
  "error_making_call": "Error making call: ",
  "delete_contact": "Delete Contact",
  "delete_confirmation": "Are you sure you want to delete this contact?\nThis action cannot be undone.",
  "cancel": "Cancel",
  "delete": "Delete",
  "contact_deleted_successfully": "Contact deleted successfully",
  "contact_updated_successfully": "Contact updated successfully",
  "error_updating_contact": "Error updating contact: ",
  "could_not_find_contact": "Could not find contact",
  "no_number_available": "No number available",
  "no_email_available": "No Email available",
  "message": "message",
  "call": "call",
  "white": "White",
  "blue": "Blue",
  "red": "Red",
  "green": "Green",
  "purple": "Purple"
};
static const Map<String,dynamic> _es = {
  "contact": "Contacto",
  "add_contact": "Añadir Contacto",
  "edit_contact": "Editar Contacto",
  "first_name": "Nombre",
  "last_name": "Apellido",
  "phone_number": "Número de Teléfono",
  "email": "Correo Electrónico",
  "permission_denied": "Permiso denegado para acceder a los contactos",
  "retry": "Reintentar",
  "request_permission": "Solicitar Permiso",
  "please_grant_permission": "Por favor, conceda permiso para acceder a los contactos en la configuración de su dispositivo.",
  "contact_added_successfully": "Contacto añadido con éxito",
  "error_adding_contact": "Error al añadir contacto: ",
  "error_accessing_contacts": "Error al acceder a los contactos: ",
  "permission_denied_contacts": "Permiso denegado",
  "error": "Error",
  "could_not_open_messages_app": "No se pudo abrir la aplicación de Mensajes",
  "ok": "OK",
  "error_opening_messages": "Error al abrir Mensajes: ",
  "could_not_open_phone_app": "No se pudo abrir la aplicación de Teléfono",
  "error_making_call": "Error al realizar llamada: ",
  "delete_contact": "Eliminar Contacto",
  "delete_confirmation": "¿Está seguro de que desea eliminar este contacto?\nEsta acción no se puede deshacer.",
  "cancel": "Cancelar",
  "delete": "Eliminar",
  "contact_deleted_successfully": "Contacto eliminado con éxito",
  "contact_updated_successfully": "Contacto actualizado con éxito",
  "error_updating_contact": "Error al actualizar contacto: ",
  "could_not_find_contact": "No se pudo encontrar el contacto",
  "no_number_available": "No hay número disponible",
  "no_email_available": "No hay correo electrónico disponible",
  "message": "mensaje",
  "call": "llamada",
  "white": "Blanco",
  "blue": "Azul",
  "red": "Rojo",
  "green": "Verde",
  "purple": "Púrpura"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "es": _es};
}
