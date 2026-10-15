//
//  DatosCulturas.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class DatosCulturas {

    // si todavia no hay imagen para el elemento se usa la de la cultura
    static func imagen(_ nombre: String, _ porDefecto: String) -> UIImage? {
        return UIImage(named: nombre) ?? UIImage(named: porDefecto)
    }

    static func obtenerCulturas() -> [Cultura] {
        return [
            Cultura(nombre: "Caral", region: "Lima (valle de Supe)",
                    descripcion: "Considerada la civilización más antigua de América, se desarrolló alrededor del 3000 a.C. Destaca por su ciudad sagrada con pirámides, plazas circulares y una sociedad organizada sin uso de armas.",
                    foto: UIImage(named: "caral"),
                    elementos: [
                        Elemento(titulo: "Pirámide Mayor",
                                 descripcion: "Es el edificio más grande de la Ciudad Sagrada de Caral. Desde ahí se dirigían las actividades religiosas y políticas de la población. Tiene una gran escalinata central y una plaza circular hundida en su frente.",
                                 foto: imagen("caral_piramide", "caral")),
                        Elemento(titulo: "Anfiteatro",
                                 descripcion: "Templo con una plaza circular hundida donde se realizaban ceremonias públicas. En este lugar se encontraron flautas hechas con huesos de pelícano y cornetas de huesos de animales, lo que muestra la importancia de la música en sus rituales.",
                                 foto: imagen("caral_anfiteatro", "caral")),
                        Elemento(titulo: "Shicras",
                                 descripcion: "Bolsas tejidas con fibra vegetal y llenas de piedras que se usaban para rellenar las plataformas de los edificios. Gracias a ellas las construcciones resistían mejor los sismos.",
                                 foto: imagen("caral_shicras", "caral"))
                    ]),
            Cultura(nombre: "Chavín", region: "Áncash (Chavín de Huántar)",
                    descripcion: "Cultura de los Andes centrales famosa por su templo de piedra con galerías subterráneas, el Lanzón monolítico y las cabezas clavas. Tuvo gran influencia religiosa en todo el territorio.",
                    foto: UIImage(named: "chavin"),
                    elementos: [
                        Elemento(titulo: "Templo de Chavín de Huántar",
                                 descripcion: "Centro ceremonial construido con bloques de piedra labrada. Por dentro tiene galerías subterráneas y canales de agua que producían sonidos durante los rituales. Fue un importante lugar de peregrinación.",
                                 foto: imagen("chavin_templo", "chavin")),
                        Elemento(titulo: "Lanzón Monolítico",
                                 descripcion: "Escultura de granito de más de 4 metros de alto que se encuentra en el centro de las galerías del templo antiguo. Representa a la divinidad principal de Chavín, con rasgos humanos y de felino.",
                                 foto: imagen("chavin_lanzon", "chavin")),
                        Elemento(titulo: "Cabezas Clavas",
                                 descripcion: "Esculturas de piedra en forma de cabeza que estaban empotradas en los muros exteriores del templo. Muestran rostros que se van transformando en felinos, relacionados con los rituales de los sacerdotes.",
                                 foto: imagen("chavin_cabezas", "chavin"))
                    ]),
            Cultura(nombre: "Paracas", region: "Ica (península de Paracas)",
                    descripcion: "Reconocida por sus finos mantos textiles, las trepanaciones craneanas y sus necrópolis. Fue una de las culturas más avanzadas en el trabajo de tejidos del antiguo Perú.",
                    foto: UIImage(named: "paracas"),
                    elementos: [
                        Elemento(titulo: "Mantos de Paracas",
                                 descripcion: "Textiles de algodón y lana bordados con figuras de seres míticos, aves y felinos en muchos colores. Se usaban para envolver los fardos funerarios y son considerados de los mejores tejidos del mundo antiguo.",
                                 foto: imagen("paracas_mantos", "paracas")),
                        Elemento(titulo: "Trepanaciones craneanas",
                                 descripcion: "Operaciones en las que se abría el cráneo con instrumentos de obsidiana y metal. Muchos cráneos muestran que los pacientes sobrevivieron porque el hueso volvió a crecer.",
                                 foto: imagen("paracas_trepanacion", "paracas")),
                        Elemento(titulo: "Necrópolis de Wari Kayan",
                                 descripcion: "Gran cementerio descubierto por Julio C. Tello en 1927, donde se encontraron cientos de fardos funerarios envueltos en mantos bordados junto con ofrendas.",
                                 foto: imagen("paracas_necropolis", "paracas"))
                    ]),
            Cultura(nombre: "Nazca", region: "Ica (valle de Nazca)",
                    descripcion: "Conocida mundialmente por las líneas y geoglifos trazados en el desierto. También construyeron acueductos subterráneos y elaboraron una cerámica policroma muy colorida.",
                    foto: UIImage(named: "nazca"),
                    elementos: [
                        Elemento(titulo: "Líneas de Nazca",
                                 descripcion: "Geoglifos trazados en el desierto que forman figuras como el colibrí, el mono, la araña y el cóndor. Muchas solo se pueden ver completas desde el aire. Son Patrimonio de la Humanidad desde 1994.",
                                 foto: imagen("nazca_lineas", "nazca")),
                        Elemento(titulo: "Acueductos de Cantalloc",
                                 descripcion: "Canales subterráneos de piedra, también llamados puquios, que llevaban agua para la agricultura. Tienen aberturas en espiral que permitían el ingreso de aire y la limpieza, y algunos siguen funcionando.",
                                 foto: imagen("nazca_cantalloc", "nazca")),
                        Elemento(titulo: "Cerámica polícroma",
                                 descripcion: "Vasijas decoradas con muchos colores donde se representan animales, plantas y seres mitológicos. Es una de las cerámicas con más variedad de colores del antiguo Perú.",
                                 foto: imagen("nazca_ceramica", "nazca"))
                    ]),
            Cultura(nombre: "Moche", region: "La Libertad y Lambayeque",
                    descripcion: "Cultura de la costa norte destacada por su cerámica escultórica (huacos retrato), la orfebrería y las huacas del Sol y de la Luna. A ella pertenece el Señor de Sipán.",
                    foto: UIImage(named: "moche"),
                    elementos: [
                        Elemento(titulo: "Huacas del Sol y de la Luna",
                                 descripcion: "Dos grandes edificios de adobe cerca de Trujillo. La Huaca de la Luna era un templo ceremonial con murales de colores, y la Huaca del Sol habría sido un centro político y administrativo.",
                                 foto: imagen("moche_huacas", "moche")),
                        Elemento(titulo: "Señor de Sipán",
                                 descripcion: "Tumba de un gobernante mochica descubierta en 1987 por Walter Alva en Lambayeque. Se encontró intacta, con joyas de oro, plata y piedras preciosas. Hoy se exhibe en el Museo Tumbas Reales de Sipán.",
                                 foto: imagen("moche_sipan", "moche")),
                        Elemento(titulo: "Huacos retrato",
                                 descripcion: "Vasijas de cerámica con rostros humanos muy realistas, donde se pueden ver gestos y expresiones. Muestran la habilidad de los alfareros moche para representar a personas de su sociedad.",
                                 foto: imagen("moche_huacos", "moche"))
                    ]),
            Cultura(nombre: "Wari", region: "Ayacucho",
                    descripcion: "Primer estado expansivo de los Andes. Construyó centros administrativos planificados y una red de caminos que luego aprovecharon los incas.",
                    foto: UIImage(named: "wari"),
                    elementos: [
                        Elemento(titulo: "Pikillacta",
                                 descripcion: "Centro administrativo ubicado en Cusco con cientos de recintos de piedra ordenados en forma de cuadrícula. Servía para controlar y almacenar productos de la región.",
                                 foto: imagen("wari_pikillacta", "wari")),
                        Elemento(titulo: "Ciudad de Wari",
                                 descripcion: "Capital del estado Wari, cerca de la actual ciudad de Ayacucho. Tenía grandes muros, templos y galerías funerarias, y llegó a ser una de las ciudades más grandes de su época.",
                                 foto: imagen("wari_ciudad", "wari")),
                        Elemento(titulo: "Tapices Wari",
                                 descripcion: "Tejidos de lana y algodón con diseños geométricos y figuras estilizadas en colores intensos. Se usaban como vestimenta de la élite y como objetos de prestigio.",
                                 foto: imagen("wari_tapices", "wari"))
                    ]),
            Cultura(nombre: "Chimú", region: "La Libertad (Chan Chan)",
                    descripcion: "Se desarrolló en la costa norte y tuvo como capital a Chan Chan, la ciudad de barro más grande de América. Fueron expertos orfebres y construyeron grandes canales de riego.",
                    foto: UIImage(named: "chimu"),
                    elementos: [
                        Elemento(titulo: "Chan Chan",
                                 descripcion: "Capital del reino Chimú y la ciudad de barro más grande de América. Sus muros están decorados con relieves de peces, aves y redes. Es Patrimonio de la Humanidad desde 1986.",
                                 foto: imagen("chimu_chanchan", "chimu")),
                        Elemento(titulo: "Orfebrería Chimú",
                                 descripcion: "Los chimú trabajaron el oro y la plata con técnicas como el laminado, la soldadura y el repujado. Elaboraron vasos, máscaras, orejeras y otros adornos.",
                                 foto: imagen("chimu_orfebreria", "chimu")),
                        Elemento(titulo: "Cerámica negra",
                                 descripcion: "Vasijas de color negro brillante que se obtenía cocinando la arcilla en hornos cerrados. Muchas tienen forma de animales, frutos o personas.",
                                 foto: imagen("chimu_ceramica", "chimu"))
                    ]),
            Cultura(nombre: "Inca", region: "Cusco",
                    descripcion: "Formaron el Tahuantinsuyo, el imperio más grande de América precolombina. Destacan por su arquitectura en piedra como Machu Picchu, el Qhapaq Ñan y la organización del ayllu.",
                    foto: UIImage(named: "inca"),
                    elementos: [
                        Elemento(titulo: "Machu Picchu",
                                 descripcion: "Ciudadela construida en el siglo XV sobre una montaña entre los Andes y la selva. Tiene templos, terrazas agrícolas y viviendas. Es Patrimonio de la Humanidad y una de las Nuevas Siete Maravillas del Mundo.",
                                 foto: imagen("inca_machupicchu", "inca")),
                        Elemento(titulo: "Sacsayhuamán",
                                 descripcion: "Complejo ceremonial y militar ubicado sobre Cusco. Sus muros en zigzag están hechos con enormes piedras que encajan perfectamente sin usar mortero.",
                                 foto: imagen("inca_sacsayhuaman", "inca")),
                        Elemento(titulo: "Qhapaq Ñan",
                                 descripcion: "Red de caminos que unía todo el Tahuantinsuyo, desde Colombia hasta Chile y Argentina. Por ella circulaban los chasquis llevando mensajes. Es Patrimonio de la Humanidad desde 2014.",
                                 foto: imagen("inca_qhapaqnan", "inca"))
                    ])
        ]
    }
}
