# Carga las librerías necesarias para usar formularios
Add-Type -AssemblyName System.Windows.Forms
# Permite usar tamaños, posiciones y gráficos
Add-Type -AssemblyName System.Drawing

# Crea un nuevo formulario (ventana)
$form = New-Object System.Windows.Forms.Form
# Texto que aparece en la barra del formulario
$form.Text = "Input Form"
# Tamaño del formulario (ancho 500, alto 250)
$form.Size = New-Object System.Drawing.Size(500,250)
# Hace que el formulario aparezca centrado en la pantalla
$form.StartPosition = "CenterScreen"

# Define la primera etiqueta (label)
$textLabel1 = New-Object System.Windows.Forms.Label
# Texto visible de la etiqueta
$textLabel1.Text = "Input 1:"
# Posición horizontal de la etiqueta
$textLabel1.Left = 20
# Posición vertical
$textLabel1.Top = 20
# Ancho de la etiqueta
$textLabel1.Width = 120

# Define la segunda etiqueta
$textLabel2 = New-Object System.Windows.Forms.Label
# Texto visible
$textLabel2.Text = "Input 2:"
# Posición horizontal
$textLabel2.Left = 20
# Posición vertical
$textLabel2.Top = 60
# Ancho
$textLabel2.Width = 120

# Define la tercera etiqueta
$textLabel3 = New-Object System.Windows.Forms.Label
# Texto visible
$textLabel3.Text = "Input 3:"
# Posición horizontal
$textLabel3.Left = 20
# Posición vertical
$textLabel3.Top = 100
# Ancho
$textLabel3.Width = 120

# Define el cuadro de texto 1
$textBox1 = New-Object System.Windows.Forms.TextBox
# Posición horizontal del textbox
$textBox1.Left = 150
# Posición vertical
$textBox1.Top = 20
# Ancho del textbox
$textBox1.Width = 200

# Define el cuadro de texto 2
$textBox2 = New-Object System.Windows.Forms.TextBox
# Posición horizontal
$textBox2.Left = 150
# Posición vertical
$textBox2.Top = 60
# Ancho
$textBox2.Width = 200

# Define el cuadro de texto 3
$textBox3 = New-Object System.Windows.Forms.TextBox
# Posición horizontal
$textBox3.Left = 150
# Posición vertical
$textBox3.Top = 100
# Ancho
$textBox3.Width = 200

# Define un valor predeterminado (cadena vacía)
$defaultValue = ""
# Asigna el valor predeterminado al textbox 1
$textBox1.Text = $defaultValue
# Al textbox 2
$textBox2.Text = $defaultValue
# Al textbox 3
$textBox3.Text = $defaultValue

# Define un botón OK
$button = New-Object System.Windows.Forms.Button
# Posición horizontal del botón
$button.Left = 360
# Posición vertical
$button.Top = 140
# Ancho del botón
$button.Width = 100
# Texto visible del botón
$button.Text = "OK"

# Define el evento que ocurre al hacer clic en el botón
$button.Add_Click({
    # Guarda los valores de los 3 textboxes dentro del formulario (propiedad Tag)
    $form.Tag = @{
        Box1 = $textBox1.Text  # Texto del cuadro 1
        Box2 = $textBox2.Text  # Texto del cuadro 2
        Box3 = $textBox3.Text  # Texto del cuadro 3
    }
    # Cierra el formulario para continuar el script
    $form.Close()
})

# Agrega el botón al formulario
$form.Controls.Add($button)
# Agrega las etiquetas
$form.Controls.Add($textLabel1)
$form.Controls.Add($textLabel2)
$form.Controls.Add($textLabel3)
# Agrega los cuadros de texto
$form.Controls.Add($textBox1)
$form.Controls.Add($textBox2)
$form.Controls.Add($textBox3)

# Muestra el formulario como una ventana modal que pausa el script hasta cerrarse
$form.ShowDialog() | Out-Null

# Retorna los valores escritos por el usuario
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3