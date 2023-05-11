import 'package:flutter/material.dart';

class Terminos extends StatelessWidget {
  const Terminos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          "Términos y Condiciones",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Introducción",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Bienvenido a nuestra aplicación. Antes de utilizarla, por favor lee detenidamente estos términos y condiciones. Al utilizar esta aplicación, aceptas estar sujeto a estos términos y condiciones a conformidad con la Ley Estatutaria 1581 de 2012 y el Decreto Reglamentario 1377 de 2013.. Si no estás de acuerdo con alguno de ellos, no utilices esta aplicación.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              "1. IDENTIDAD Y DOMICILIO DEL RESPONSABLE DEL TRATAMIENTO DE DATOS PERSONALES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "El responsable del tratamiento de los datos personales suministrados a través de la Aplicación es FOODHUB S.A.S., una sociedad debidamente constituida bajo las leyes colombianas.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              "2. FINALIDADES DEL TRATAMIENTO DE DATOS PERSONALES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "La recolección, almacenamiento, uso, circulación y supresión de los datos personales suministrados por los usuarios de la Aplicación se realiza con las siguientes finalidades: \na) Permitir el acceso a la Aplicación y su utilización por parte de los usuarios. \nb) Gestionar y mantener actualizada la cuenta de cada usuario en la Aplicación. \nc) Procesar y gestionar los pedidos de los usuarios. \nd) Enviar notificaciones a los usuarios acerca de nuevos productos, ofertas y promociones relacionados con la plicación.\ne) Realizar estudios estadísticos y de mercado para mejorar la calidad de los productos y servicios ofrecidos en la Aplicación. \nf) Cumplir con las obligaciones legales y contractuales adquiridas por FOODHUB S.A.S.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              "3. DERECHOS DE LOS TITULARES DE LOS DATOS PERSONALES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "De acuerdo con lo dispuesto en la Ley Estatutaria 1581 de 2012 y el Decreto Reglamentario 1377 de 2013, los titulares de los datos personales suministrados a través de la Aplicación tienen los siguientes derechos:\na) Conocer, actualizar y rectificar sus datos personales frente a FOODHUB S.A.S. en su calidad de responsable del tratamiento de los mismos.\nb) Solicitar prueba de la autorización otorgada a FOODHUB S.A.S. como responsable del tratamiento de sus datos personales.\nc) Ser informados por FOODHUB S.A.S., previa solicitud, respecto del uso que se ha dado a sus datos personales.\nd) Presentar ante la Superintendencia de Industria y Comercio quejas por infracciones a lo dispuesto en la Ley Estatutaria 1581 de 2012 y el Decreto Reglamentario 1377 de 2013.\ne) Revocar la autorización y/o solicitar la supresión de los datos personales suministrados a FOODHUB S.A.S.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              "4. PROCEDIMIENTO PARA EL EJERCICIO DE LOS DERECHOS DE LOS TITULARES DE LOS DATOS PERSONALES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Los titulares de los datos personales suministrados a través de la Aplicación podrán ejercer sus derechos enviando una solicitud a FOODHUB S.A.S. a través del correo electrónico [correo electrónico de contacto de FOODHUB]. La solicitud deberá contener como mínimo la siguiente información: \n(i) nombre completo del titular de los datos personales, \n(ii) número de identificación del titular de los datos personales, \n(iii) descripción de los hechos que dan lugar a la solicitud, \n(iv) dirección física o electrónica para recibir notificaciones y \n(v) documentos que se quiera hacer valer.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              "5. AUTORIZACIÓN PARA EL TRATAMIENTO DE LOS DATOS PERSONALES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "La aceptación de la presente Política implica la autorización por parte del usuario para que FOODHUB S.A.S. recolecte, almacene, utilice, circule y suprima los datos personales suministrados por él, de acuerdo con las finalidades descritas en el punto 2 de la presente Política.s",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              "6. MODIFICACIONES A LA POLÍTICA DE TRATAMIENTO DE DATOS PERSONALES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "FOODHUB S.A.S. se reserva el derecho de modificar la presente Política en cualquier momento. Cualquier modificación será publicada en la Aplicación y se entenderá que ha sido aceptada por los usuarios de la Aplicación a partir de su publicación. Por lo tanto, se recomienda revisar periódicamente la presente Política.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              "7. VIGENCIA DE LA POLÍTICA DE TRATAMIENTO DE DATOS PERSONALES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "La presente Política de tratamiento de datos personales tiene una vigencia indefinida y rige a partir de su publicación en la Aplicación. En caso de que se realicen modificaciones a la Política, se informará oportunamente a los usuarios de la Aplicación a través de la misma y se publicará una versión actualizada de la Política en la Aplicación.\nEs importante que los usuarios de la Aplicación revisen periódicamente la Política de tratamiento de datos personales para estar informados sobre cualquier cambio que se haya realizado en ella. Si los usuarios no están de acuerdo con los términos de la Política, deberán abstenerse de utilizar la Aplicación y deberán informar a FOODHUB S.A.S. para que proceda a cancelar sus datos personales en su base de datos.\nLa vigencia de la presente Política se ajustará a lo establecido en la ley colombiana en materia de protección de datos personales y a las disposiciones de las autoridades competentes en la materia.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
