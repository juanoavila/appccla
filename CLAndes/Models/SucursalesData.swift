struct Envelope: Codable{
    var Envelope : Body
}

struct Body: Codable{
    var Body : EntBusquedaSucursalConCajaListaOutABM
}

struct EntBusquedaSucursalConCajaListaOutABM: Codable {
    var EntBusquedaSucursalConCajaListaOutABM : sucursalLista
}

struct sucursalLista: Codable{
    var sucursalLista : sucursal
}

struct sucursal: Codable{
    var sucursal : [ObjSucursal]
}

struct ObjSucursal: Codable {
    var nombreSucursal: String
    var longitud: String
//    var latitud: String?
//    var horario: String
//    var codigoSucursal: String?
//    var turnomovil: String
    //var direccion: direccion
}

struct direccion: Codable {
    var zona: zona
    var numero: Int
    var codigoPostal: Int
    var ciudad: ciudad
    var calle: String
    var comuna: comuna
    var region: region
}

struct zona: Codable {
    var descripcion: String
    var codigo: Int
    var nombre: String?
}

struct ciudad: Codable {
    var descripcion: String
    var codigo: Int
    var nombre: String?
}

struct comuna: Codable {
    var descripcion: String
    var codigo: Int
    var nombre: String?
}

struct region: Codable {
    var descripcion: String
    var codigo: Int
    var nombre: String?
}

