<?xml version="1.0" encoding="UTF-8"?>

<!-- Se ha utilizado XSL 2.0 gracias al procesador de Saxon 9, permitiéndonos utilizar funciones avanzadas -->
<!-- Para procesar el XML con el procesador Saxon 9, hemos utilziado un script llamado 'process.sh' que se encuentra en la raiz -->
<!-- https://stackoverflow.com/questions/6315260/can-we-do-xslt-2-0-with-netbeans-7 -->
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:functx="http://www.functx.com"
                xpath-default-namespace="http://www.practicasipc.edu">
    
<xsl:output method="html" indent="yes"/>

<xsl:variable name="DIR" select='"."' />
<xsl:variable name="CSS_DIR" select='"./css/style.css"' />

<!--Función para poner en mayúsculas las palabras pasadas, posible gracias a XSL 2.0 -->
<xsl:function name="functx:capitalize-first"> <!-- Contiene Función de formateo de cadenas -->
  <xsl:param name="arg"/>
  <xsl:sequence select="concat(upper-case(substring($arg,1,1)), substring($arg,2)) "/>
</xsl:function>


<!--Plantilla principal-->
<xsl:template match="/">
    <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1" />
	        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" />
            <link rel="stylesheet" href="{$CSS_DIR}" />
            <title>Recetas Canarias</title>
        </head>
        <body>
            <!-- Contiene Generación de Datos númericos -->
            <!--Variables utilizadas para la generación y el cálculo de datos númericos-->
            <xsl:variable name="numberOfRecipes" select="count(recipe-book/recipe)" />
            <xsl:variable name="numberOfIngredients" select="count(recipe-book/recipe/ingredient-list/ingredient) - (count(recipe-book/recipe/ingredient-list/ingredient) mod 10)" />
            <xsl:variable name="numberOfInstructions" select="count(recipe-book/recipe/instruction-list/instruction)" />
            <xsl:variable name="numberOfHours" select="ceiling( sum(recipe-book/recipe/@duration) div 3600)" />

            <!--Cabecera de la página principal del libro de recetas-->
            <header class="container-fluid container y-margin align-center">
                <div class="row">
                    <h1>Libro de recetas Canarias</h1>
                    <hr></hr>
                </div>
                <div class="row">
                    <div class="index-subtitle-box col-md-10 col-md-offset-1">
                        <h2 class="index-subtitle"> Utiliza más de <xsl:value-of select="$numberOfIngredients" /> ingredientes con esta recopilación de <xsl:value-of select="$numberOfRecipes" /> recetas canarias 
                        en las que se recogen <xsl:value-of select="$numberOfInstructions" /> pasos a seguir para que tus cocinados sean perfectos. Este fabuloso libro asegura aproximadamente <xsl:value-of select="$numberOfHours" /> horas
                        de diversión y cocinado para demostrar a tu familia quién es el mejor cocinero de tu casa.</h2>
                    </div>
                </div>
            </header>
            
            <!--Cuerpo de la página principal del libro de recetas-->
            <!--Por cada receta dentro del libro de recetas aplicamos la plantilla para recetas-->
            <main class="container-fluid container align-center top-padding">
                <div class="row">
                    <xsl:for-each select="recipe-book/recipe">
                        
                        <xsl:apply-templates select="." />
                        
                    </xsl:for-each>
                </div>
            </main>
            
            <!--Pie de página de la página principal del libro de recetas-->
            <footer class="container-fluid container align-center y-margin">
                <hr></hr>
                <h2>Autores</h2>
                <div class="row">
                    <p class="col-md-4">Ángel Luis Igareta Herráiz</p>
                    <p class="col-md-4">Carlos Domínguez García</p>
                    <p class="col-md-4">Daute Rodríguez Rodríguez</p>
                </div>
                
            </footer>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
        </body>
    </html>
</xsl:template>

<!--Plantilla para las recetas-->
<!--Por cada receta creamos un cuadro con su nombre y su imagen que será mostrado en la página principal-->
<!--También generamos una página HTML para cada receta en la que están recogidos sus atributos y componentes: imagen, lista de ingreditentes etc...-->
<xsl:template match="recipe">
    
    <!--Creamos el cuadro para la página principal -->
    <xsl:variable name="index" select="count(preceding-sibling::recipe)" /> <!-- Contiene Cálculo -->
                        
    <xsl:if test="($index mod 2) = 1"> <!-- Contiene Condicionales -->
        <a href="{$DIR}/{@name}.html"> 
            <div class="col-md-5 y-padding recipe-box col-md-offset-2">
                <h3><xsl:value-of select="@name"/></h3>
                <img src="{photo/@src}" alt="{@name}" class="index-img"/>
            </div>
        </a>
    </xsl:if>
    
    <xsl:if test="($index mod 2) = 0"> <!-- Contiene Condicionales -->
        <a href="{$DIR}/{@name}.html">
            <div class="col-md-5 y-padding recipe-box">
                <h3><xsl:value-of select="@name"/></h3>
                <img src="{photo/@src}" alt="{@name}" class="index-img"/>
            </div>
        </a>
    </xsl:if>
    
    <!-- Creamos los documentos html de cada receta gracias a result-document, herramienta de XSL 2.0-->
    <xsl:result-document href="{$DIR}/{@name}.html" method="html"> <!-- Contiene Funciones de XSL 2.0 -->
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
	            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" />
                <link rel="stylesheet" href="{$CSS_DIR}" /> 
                <title><xsl:value-of select="@name"/></title>
            </head>
            <body>
                
                <!--Cabecera de las páginas de recetas, mostramos el nombre de la receta y sus atributos dentro de un cuadro-->
                <header class="fluid-container container align-center">
                    <div class="row y-margin">
                        <h1><xsl:value-of select="@name"/></h1>
                    </div>
                    
                    <div class="fluid-container recipe-info-bar y-margin">
                        <div class="row">
                            <div class="col-sm-1"  id="recipe-info-bar-image">
                                <img class="recipe-info-bar-image" id="autor" src="https://png.icons8.com/metro/2x/edit.png" alt="autor" />
                            </div>
                            <div class="col-sm-3 align-left" id="recipe-info-bar-p">
                                <p class="recipe-info-bar-p"><xsl:value-of select="@author" /></p>
                            </div>
                            
                            <div class="col-sm-1 align-right" id="recipe-info-bar-image">
                                <xsl:choose> <!-- Contiene Switch -->
                                    <xsl:when test="@difficulty = 'fácil'">
                                        <svg class="recipe-info-bar-image" alt="dificultad" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
                                            <path fill-opacity=".3" d="M1 16h15V1z"/><path d="M1 16h7V9z"/>
                                        </svg>  
                                    </xsl:when>
                                    <xsl:when test="@difficulty = 'media'">
                                        <svg class="recipe-info-bar-image" alt="dificultad" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
                                            <path fill-opacity=".3" d="M1 16h15V1z"/><path d="M1 16h9V7z"/>
                                        </svg>
                                    </xsl:when>
                                    <xsl:when test="@difficulty = 'difícil'">
                                        <svg class="recipe-info-bar-image" alt="dificultad" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
                                            <path fill-opacity=".3" d="M1 16h15V1z"/><path d="M1 16h11V5z"/></svg>
                                    </xsl:when>
                                </xsl:choose>
                            </div>
                            <div class="col-sm-3 align-left" id="recipe-info-bar-p">
                                <p class="recipe-info-bar-p">Dificultad <xsl:value-of select="@difficulty" /></p>
                            </div>
                            
                            <div class="col-sm-1 align-right" id="recipe-info-bar-image">
                                <img class="recipe-info-bar-image" src="https://png.icons8.com/metro/2x/clock.png" alt="tiempo" />
                            </div>
                            <div class="col-sm-3 align-left" id="recipe-info-bar-p">
                                <xsl:variable name="hour" select="floor(@duration div 3600)" /> <!-- Contiene Formateo -->
                                <xsl:variable name="min" select="(@duration mod 3600) div 60" />  
                                
                                <p class="recipe-info-bar-p">
                                    <xsl:if test="$hour != 0">
                                        <xsl:value-of select="$hour" /> hora
                                    </xsl:if>
                                    
                                    <xsl:if test="$min != 0">
                                        <xsl:value-of select="$min" /> min. 
                                    </xsl:if>
                                </p>
                            </div>
                            
                        </div>
                    
                        <div class="row">
                            <div class="col-sm-2 align-right" id="recipe-info-bar-image">
                                <img class="recipe-info-bar-image" src="https://png.icons8.com/windows/2x/conference-call.png" alt="comensales" />
                            </div>
                            <div class="col-sm-4 align-left" id="recipe-info-bar-p">
                                <p class="recipe-info-bar-p">
                                    <xsl:if test="@number-of-people > 1">
                                        <xsl:value-of select="@number-of-people" /> comensales
                                    </xsl:if>
                                    <xsl:if test="@number-of-people = 1">
                                        <xsl:value-of select="@number-of-people" /> comensal
                                    </xsl:if>
                                </p>
                            </div>
                            
                            <div class="col-sm-2 align-right" id="recipe-info-bar-image">
                                <img class="recipe-info-bar-image" src="https://png.icons8.com/ios/2x/meal-filled.png" alt="tipo" />
                            </div>
                            <div class="col-sm-4 align-left" id="recipe-info-bar-p">
                                <p class="recipe-info-bar-p">
                                    Tipo: <xsl:value-of select="functx:capitalize-first(@course)" /> <!-- Contiene Operaciones sobre cadenas -->
                                </p>
                            </div>
                        </div>
                    </div>
                        
                </header>
                
                <!--Cuerpo principal de las páginas de recetas, mostramos la imagen de la receta, y aplicamos las plantillas para la lista de ingredientes y la lista de instrucciones-->
                <main class="fluid-container align-center container">
                    
                <div class="row">
                    <img class="recipe-image" src="{photo/@src}" alt="{@name}" />
                </div>
                    
                    <xsl:apply-templates select="ingredient-list"/>
                    <xsl:apply-templates select="instruction-list"/>
                    
                </main>
                
                <!--Pie de página de las páginas de recetas, se trata de un "navegador", puedes ir a la receta anterior, a la posterior o al índice de recetas-->
                <footer class="fluid-container container y-margin">
                    
                    <hr></hr>
                    
                    <xsl:variable name="back-node" select="preceding-sibling::recipe[1]"/>
                    <xsl:variable name="forward-node" select="following-sibling::recipe[1]"/>
                    
                    <div class="row">
                        <div class="col-sm-4 align-left">
                        <!--Si no es la primera -->
                            <xsl:if test="not($index = 0)">
                                
                                <a href="{$DIR}/{$back-node/@name}.html">
                                    <img id="back-arrow" src="https://png.icons8.com/go-back/win8/1600" alt="Atrás"/>
                                </a>
                            </xsl:if>
                        </div>
                        
                        <div class="col-sm-4 align-center">
                            <a href="../index.html">
                                <img id="home" src="https://png.icons8.com/material/2x/top-menu.png" alt="home" />
                            </a>
                        </div>
                        
                        <div class="col-sm-4 align-right">
                        <!--Si no es el último muestro flecha siguiente-->
                            <xsl:if test="not($index = number(count(/recipe-book/recipe) - 1))">
                                <a href="{$DIR}/{$forward-node/@name}.html">
                                    <img id="forward-arrow" src="https://png.icons8.com/go-back/win8/1600" alt="Adelante"/>
                                </a>
                            </xsl:if>
                        </div>
                    </div>    
                </footer>
            </body>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
        </html>
    </xsl:result-document>
</xsl:template>

<!--Plantilla para la lista de ingredientes-->
<!--Simplemente se ordenan alfabéticamente y muestran los ingredientes necesarios para elaborar la receta-->
<xsl:template match="ingredient-list">

    <div class="y-margin y-padding recipe-info">
        <div class="row align-left recipe-ingredients">
            <div class="col-md-1 no-padding">
                <img id="ingredients" src="https://png.icons8.com/metro/2x/ingredients.png" alt="Ingredientes" />
            </div>
            
            <div class="col-md-10 col-md-offset-1 no-padding">
                <h3>Ingredientes</h3>
            </div>
            
        </div>
        
        <div class="row align-left recipe-ingredients">
            <ul>
                <xsl:for-each select="ingredient">
                    
                    <xsl:sort select="@name" /> <!-- Contiene Ordenaciones -->
                    
                    <li>
                        <xsl:value-of select="@name"/>
                        <xsl:text> : </xsl:text>
                        <xsl:value-of select="@quantity"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@unit"/>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </div>
    
</xsl:template>

<!--Plantilla para la lista de pasos/instrucciones-->
<!--Ordenamos la lista de instrucciones y la mostramos siguiendo un formato específico -->
<xsl:template match="instruction-list">
    
    <div class="y-margin y-padding recipe-info">
    
        <div class="row align-left recipe-instructions">
            <div class="col-md-1 no-padding">
                <img id="instructions" src="https://png.icons8.com/metro/2x/cooking-pot.png" alt="Instrucciones" />
            </div>
            
            <div class="col-md-10 col-md-offset-1 no-padding">
                <h3>Instrucciones a seguir</h3>
            </div>
        </div>
        
        <div class="row align-left recipe-instructions">
            <xsl:for-each select="instruction">
                <xsl:sort select="@number"/>
                <xsl:number value="position()" format="1. " />
                <xsl:value-of select="."/><br />
            </xsl:for-each>
        </div>
        
    </div>
    
</xsl:template>

</xsl:stylesheet>