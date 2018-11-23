import Foundation

struct EstructuraConvenios: Codable{
    var codigo: String?
    var mensaje: String?
    var respuesta: Convenios?
}

struct Convenios: Codable {
    var convenios: [Convenio]
}

struct Convenio: Codable{
    var id: String?
    var nombre: String?
    var resumen_beneficio: String?
    var fecha_inicio: String?
    var fecha_termino: String?
    var legales: String?
    var forma_canje: String?
    var texto_sms: String?
    var descripcion_corta: String?
    var direccion: String?
    var region: String?
    var ciudad: String?
    var comuna: String?
    var longitud: String?
    var latitud: String?
    var descripcion_canje: String?
    var region_id: String?
    var nombre_pilar: String?
    var icono_pilar: String?
    var nombre_categoria: String?
    var icono_categoria: String?
    var distance: String?
    
}
