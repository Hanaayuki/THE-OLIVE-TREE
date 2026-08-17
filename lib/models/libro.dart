class Libro {
  final int? id;
  final String titulo;
  final String autor;
  final String? portada;
  final String? rutaPdf;
  final String estado;
  final int? calificacion;
  final String? resena;
  // Si alguien lee esto que leea esto sting? reseña; hace 
  // que reseña pueda ser nulo, es decir que no tenga valor, y si no tiene valor no se va a mostrar nada en la app, pero si tiene valor se va a mostrar la reseña del libro.
  //mejor dicho iene un signo de interrogación porque puede que al principio no tengas una reseña escrita, así que es "opcional"

  Libro({
    this.id,
    required this.titulo,
    required this.autor,
    this.portada,
    this.rutaPdf,
    required this.estado,
    this.calificacion,
    this.resena,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'portada': portada,
      'rutaPdf': rutaPdf,
      'estado': estado,
      'calificacion': calificacion,
      'resena': resena,
    };
  }

  factory Libro.fromMap(Map<String, dynamic> map) {
    return Libro(
      id: map['id'],
      titulo: map['titulo'],
      autor: map['autor'],
      portada: map['portada'],
      rutaPdf: map['rutaPdf'],
      estado: map['estado'],
      calificacion: map['calificacion'],
      resena: map['resena'],
    );
  }
}