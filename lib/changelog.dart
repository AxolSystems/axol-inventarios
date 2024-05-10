class Changelog {
  static String get main => '''
# Registro de cambios

## [1.0.13] - 2024-05-09
### Modificado
- Descarga de estado de inventario a determinada fecha omitiendo folio de movimiento seleccionado.
### Corregido
- Error en descarga de archivo de nota de venta cuando más de una persona crea una nueva nota de venta a la vez.

## [1.0.12+] - 2024-05-06
### Corregido
- Error que no guardaba notas de venta al guardar más de una al mismo tiempo.

## [1.0.11] - 2024-05-05
### Añadido
- Descarga CSV de estado de inventario hasta una fecha determinada (limitada hasta una consulta de 1000 registros).
- Descarga CSV de movimientos de un rango de fecha determinado.
### Corregido
- Error que reiniciaba las vistas de notas de ventas y clientes cuando se salía de una ventana de detalles.
- Error en campo de texto de ventana de búsquedas de productos que movía el cursor al final de la linea cuando se intentaba editar en otra posición.
- En el formulario de traspasos, se elimino de la lista de almacenes destino el almacén de origen, para así evitar hacer traspasos al mismo almacén por error.

## [1.0.10] - 2024-05-01
### Añadido
- Filtro por clave en notas de ventas y remisiones. Al escribir en el buscador "clave:" y luego el número de la nota, se filtrara dicha nota; puede filtrar una lista de notas en especifico escribiendo cada número de nota separado por una coma; también puede filtrar un rango escribiendo un guión entre dos números de notas.
- Descarga en csv de tabla con los datos de las notas de ventas y remisiones filtrados en el momento.

## [1.0.9] - 2024-05-01
### Modificado
- Vista responsiva en modulo de reportes de venta.
- Formato pdf de notas de venta.
### Corregido
- Formato a dos decimales del peso de nota de venta.

## [1.0.8] - 2024-04-28
### Añadido
- Tipo de cuenta con permiso de lectura.
- Modulo de inventario para cuenta de vendedor.
### Corregido
- Error en formula para restar reportes de ventas a inventarios.
### Modificado
- Vista responsiva en modulo de inventarios.
- Vista responsiva en modulo de ventas.
- Vista responsiva en modulo de listas pata cartas porte.

## [1.0.7] - 2024-04-21
### Añadido
- Descarga de archivos csv de estado de inventario del almacén seleccionado.
- Ahora es posible editar las listas para cartas porte y reportes de venta hasta 24 horas después de haber sido creadas.
### Modificado
- Se agregó nombre de almacén a vista de inventario.
- Cambio en formato de archivo csv para estado de inventario.
### Corregido
- Error en calculo de estado de inventario con descuento de reporte de ventas, el cual no sumaba las cantidades de los productos con la misma clave.

## [1.0.6] - 2024-04-17
### Añadido
- Ventana emergente de confirmación de guardado para nueva lista de carta porte y nuevo reporte de venta.
- Descarga de archivos csv para reportes de ventas.
- Descarga de archivos csv de estado de inventario descontando ventas del reporte seleccionado.
### Corregido
- Formula de calculo para valor total de mercancía en listas para cartas porte.

## [1.0.5] - 2024-04-15
### Corregido
- Error en buscadores de las vistas de inventario que no reiniciaba el contador de páginas de la listas consultadas en la base de datos.
- Error en buscadores de las vistas de notas de venta que impedía actualizar el número de página y de registros consultados.
### Añadido
- Botón para cerrar sesión en la barra de navegación lateral.
- Botón para eliminar elemento del formulario para nueva lista de carta porte, ubicado en vista de detalles de fila de carta porte. Se accede a dicha vista al dejar presionado la fila que se requiere revisar.
### Próximos cambios
- En proceso para agregar reportes de ventas.

## [1.0.4] - 2024-04-11
### Añadido
- Agregado buscador para formulario de nuevo elemento en listas de carta porte.
- Agregado soporte en markdown para notas de versión.
### Modificado
- Se ajustaron los tamaños de las celdas en el formulario de nuevo movimiento al inventario, y se agregó peso total de los movimientos agregados.
### Corregido
- Corrección de error que impedía guardar movimientos al inventario cuando la cantidad era menor a uno.

## [1.0.3] - 2024-04-07
### Añadido
- Se agregaron la creación de listas para cartas porte.
### Modificado
- Se cambio el diseño de la barra de navegación para agregar sus respectivas etiquetas.

## [1.0.2] - 2024-03-26
### Corregido
- Corrección en formulario de notas de ventas de error que indicaba stock insuficiente cuando la cantidad era la misma que la stock existente.
- Corrección de error en campo de texto de almacén, el cual al escribir directamente con teclado el número del almacén, no guardaban el almacén consultado en la base de datos.

## [1.0.1] - 2024-03-25
### Corregido
- Corrección de error en formulario de nuevas notas de venta y remisiones, el cual indicaba que no había stock suficiente en cualquier situación o dejaba la página cargando todo el tiempo. 
- Ahora al cancelar una nota de venta o remisión también se guarda el movimiento en el historial de movimientos.
### Modificado
- Se cambió el título de la vista de inventario, antes se llamaba "Menú de almacenes", ahora "Inventario".
''';
}
