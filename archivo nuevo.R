# Librer�a empleada
install.packages("rlang")
library("readr")
library("readxl")
install.packages(c('readr','plyr','dplyr','tidyr','plm','ggplot2'))
library("readr")
library("plyr")
library("dplyr")
library("tidyr")
library("plm")
library("ggplot2")
library("rlang")
# Importaci�n de datos
library(readxl)
library(readxl)
WB_Data <- read_excel("C:/Users/Usuario/Downloads/excel_def..xlsx")

#
head(WB_Data)

head(WB_Data[order(WB_Data$A�o),])
names(WB_Data)
library(dplyr) # Para transformar con funciones concatenadas mediante el fragmento %>%
WB_Data <- WB_Data %>%
  mutate_if(is.character,factor)
summary(WB_Data)


desempleo <- WB_Data[WB_Data$Variable=="Desempleo",]
gasto_publico <- WB_Data[WB_Data$Variable=="Gasto publico - Gasto (% del PIB)",]
deficit <- WB_Data[WB_Data$Variable=="Deficit o Superavit Fiscal - Deuda del gobierno central, total (% del PIB)",]
inflacion <- WB_Data[WB_Data$Variable=="Inflaci�n",]
masa_monetaria <- WB_Data[WB_Data$Variable=="Masa Monetaria",]
tasa_interes_real <- WB_Data[WB_Data$Variable=="Tasa de interes real",]

################
library(tidyr)
desempleo <- desempleo %>% 
  gather(Pa�s, desemp, Colombia:Guatemala)
desempleo$Variable<-NULL
head(desempleo)
print(desempleo)
#####################
# desempleo$Pa�s <- factor(substring(desempleo$Pa�s,2,4))
# desempleo <- desempleo[,2:4]
# head(desempleo)
#########################
gasto_publico <- gasto_publico %>% 
  gather(Pa�s, gasto_publ, Colombia:Guatemala)
gasto_publico$Variable<-NULL
head(gasto_publico)
#####################
# gasto_publico$Pa�s <- factor(substring(gasto_publico$Pa�s,2,4))
# gasto_publico <- gasto_publico[,2:4]
# head(gasto_publico)
###################

deficit <- deficit %>% 
  gather(Pa�s, def, Colombia:Guatemala)
deficit$Variable<-NULL
head(deficit)

################
# deficit$Pa�s <- factor(substring(deficit$Pa�s,2,4))
# deficit <- deficit[,2:4]
# head(deficit)
#################
inflacion <- inflacion %>% 
  gather(Pa�s, infla, Colombia:Guatemala)
inflacion$Variable<-NULL
head(inflacion)

##########
# inflacion$Pa�s <- factor(substring(inflacion$Pa�s,2,4))
# inflacion <- inflacion[,2:4]
# head(inflacion)
########################
masa_monetaria <- masa_monetaria %>% 
  gather(Pa�s, masa_mone, Colombia:Guatemala)
masa_monetaria$Variable<-NULL
head(masa_monetaria)

##########################
# masa_monetaria$Pa�s <- factor(substring(masa_monetaria$Pa�s,2,4))
# masa_monetaria <- masa_monetaria[,2:4]
# head(masa_monetaria)
##########################
tasa_interes_real <- tasa_interes_real %>% 
  gather(Pa�s, tasa_int_re, Colombia:Guatemala)
tasa_interes_real$Variable<-NULL
head(tasa_interes_real)
#################################
# tasa_interes_real$Pa�s <- factor(substring(tasa_interes_real$Pa�s,2,4))
# tasa_interes_real <- tasa_interes_real[,2:4]
# head(tasa_interes_real)

# memory.limit(4000)
library(plyr)
datos <- join_all(list(inflacion,gasto_publico,deficit,desempleo,masa_monetaria,tasa_interes_real), by=c("A�o","Pa�s"), type='left')
head(datos)
library(plm)
df_datos<-pdata.frame(datos, index = c("A�o", "Pa�s"))
head(df_datos)
# library(openxlsx)
# write.xlsx(datos,"base_final.xlsx")

head(datos[order(datos$A�o),])

# tabla de contingencia
# periodos hace presencia cada unidad muestral (en este caso, cada pa�s):
with(datos, table(Pa�s,A�o))

#diagrama de dispersi�n para mirar la posible relaci�n entre dos de las variables:
library(repr)
options(repr.plot.width=21, repr.plot.height=10) #definir espacio pa grafico
####################################################################
#cambiar nombres , preguntar profesor
names(datos)
colnames(datos)<-c("a�o","pais","inflacion","gasto_publico","deficit","desempleo","masa_monetaria","Tasa_interes")

library(ggplot2)
ggplot(datos, aes(masa_monetaria, desempleo)) +
  geom_point(alpha = 0.6, show.legend = FALSE) +
  #scale_colour_manual(values = pais_colors) +
  scale_size(range = c(2, 10)) +
  scale_x_log10() +
  geom_smooth() +
  facet_wrap(~a�o) +
  theme(axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 80))
###
ggplot(datos, aes(x = a�o, y = masa_monetaria, group = 1)) +
  geom_line() + geom_point() +
  facet_wrap(~pais, ncol = 5) +
  theme(axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 10, angle = 80, vjust = 0.5),
        axis.title = element_text(size = 14),
        legend.title=element_text(size=12), 
        legend.text=element_text(size=12),
        strip.text = element_text(size = 14))
options(repr.plot.width=8, repr.plot.height=8) #?

ggplot(datos, aes(x = a�o, y = inflacion, group = 1)) +
  geom_line() + geom_point() +
  facet_wrap(~pais, ncol = 5) +
  theme(axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 10, angle = 80, vjust = 0.5),
        axis.title = element_text(size = 14),
        legend.title=element_text(size=12), 
        legend.text=element_text(size=12),
        strip.text = element_text(size = 14))
options(repr.plot.width=8, repr.plot.height=8)



head(datos)
head(datos[order(datos$a�o),])

#par(mfcol=c(3,1))

#matriz de diagrama de dispersion
pairs(datos$inflacion~datos$desempleo+datos$masa_monetaria
      +datos$gasto_publico+datos$deficit+
        datos$Tasa_interes,main="matriz de diagrama de dispersion")


#############################################################
# Llamamos la librer�a requerida: "para crear indice
library(plm)
# Creamos el nuevo objeto y el �ndice:
df_datos<-pdata.frame(datos, index = c("a�o", "pais"))
head(df_datos)

# Ya configurado, podemos establecer si se trata de un p�nel 
# balanceado o no mediante una simple prueba l�gica:
is.pbalanced(df_datos)
#############################################################

#Modelos de Datos de P�nel (Efectos Fijos y Efectos Aleatorios)
#Yit=??0+??1Xit+??2Kit+eit
library(plyr)
library(dplyr) # Para transformar con funciones concatenadas mediante el fragmento %>%
datos <- datos %>%
mutate_if(is.character,factor)
summary(datos)
#### este codigo anterior lo vuelve fcactor para que?

# llamar lo que habiamos hecho antes con los indices
head(df_datos)

options(repr.plot.width=12, repr.plot.height=8) #marco de cada cuadrito?

ggplot(data = datos, aes(x = a�o, y = inflacion)) +
  geom_point() + labs(x = '', y='', title = 'Evolucion de la inflacion\nen America Latina') +
  facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))
#Not all of the characters in C:/Users/Usuario/Downloads/prof_econo.R could be encoded using ISO8859-1. 
#To save using a different encoding, choose "File | Save with Encoding..." from the main menu. �?
ggplot(data = datos, aes(x = a�o, y = desempleo)) +
  geom_point() + labs(x = '', y='', title = 'Evoluci�n del desempleo\nen Am�rica Latina') +
  facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

ggplot(data = datos, aes(x = a�o, y = gasto_publico)) +
  geom_point() + labs(x = '', y='', title = 'Evoluci�n del Gasto publico\nen Am�rica Latina') +
  facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

ggplot(data = datos, aes(x = a�o, y = deficit)) +
  geom_point() + labs(x = '', y='', title = 'Evoluci�n del Deficit\nen Am�rica Latina') +
  facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

##ELIMINAR LA VARIABLE DEFICIT PQ NO SIVER, NO HAY DATOS###########
datos_2.1 <- datos[datos$pais != 'Bolivia',]
datos_2<- data.frame(datos_2.1$a�o,datos_2.1$pais,datos_2.1$inflacion,datos_2.1$gasto_publico,datos_2.1$desempleo,datos_2.1$masa_monetaria,datos_2.1$Tasa_interes)

colnames(datos_2)<-c("periodo","pais","inflacion","gasto_publico","desempleo","masa_monetaria","Tasa_interes")
#####################################################################
# datos$deficit <- NULL

summary(datos_2)

ggplot(data = datos_2, aes(x = periodo, y = gasto_publico)) +
  geom_point() + labs(x = '', y='', title = 'Evoluci�n del gasto publico\nen Am�rica Latina') +
  facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

ggplot(data = datos_2, aes(x = periodo, y = inflacion)) +
  geom_point() + labs(x = '', y='', title = 'Evoluci�n del inflacion\nen Am�rica Latina') +
  facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))


#dispersion en los datos, podemos probar con diagramas de caja:
#tomar decisiones sobre casos de muy pocas observaciones
#o valores extremos
################
ggplot(data = datos_2, aes(x = pais, y = inflacion)) +
  geom_boxplot() + labs(x = '', y='', title = 'Evoluci�n del inflacion\nen Am�rica Latina') +
  #facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

ggplot(data = datos_2, aes(x = pais, y = desempleo)) +
  geom_boxplot() + labs(x = '', y='', title = 'Evoluci�n del desempleo\nen Am�rica Latina') +
  #facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

ggplot(data = datos_2, aes(x = pais, y = Tasa_interes)) +
  geom_boxplot() + labs(x = '', y='', title = 'Evoluci�n de la Tasa de interes\nen Am�rica Latina') +
  #facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

ggplot(data = datos_2, aes(x = pais, y = masa_monetaria)) +
  geom_boxplot() + labs(x = '', y='', title = 'Evoluci�n de la Masa monetaria\nen Am�rica Latina') +
  #facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

ggplot(data = datos_2, aes(x = pais, y = gasto_publico)) +
  geom_boxplot() + labs(x = '', y='', title = 'Evoluci�n de Gasto Publico\nen Am�rica Latina') +
  #facet_wrap(.~stringr::str_wrap(pais, 10)) +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size = 14),
        legend.position = 'none',
        plot.title = element_text(hjust = 0.5, size = 24, face = 'bold'))

#POR LO QUE ES POR A�O Y NO SIRVE
# ggplot(data = datos, aes( x = a�o, y = inflacion)) + geom_boxplot() +
#   theme(axis.text.x = element_text(vjust = .5)) + 
#   labs(x = '', y = '', title = 'Inflacion en Am�rica Latina')  +
#   theme(axis.text.x = element_text(size = 14),
#         axis.text.y = element_text(size = 14),
#         plot.title = element_text(size = 28, hjust = 0.5))

#POR LO QUE ES A�O Y NO SIRVE
# ggplot(data = datos, aes( x = a�o, y = desempleo)) + geom_boxplot() +
#   theme(axis.text.x = element_text(vjust = .5)) + 
#   labs(x = '', y = '', title = 'Inflaci�n en Am�rica Latina') +
#   theme(axis.text.x = element_text(size = 14),
#         axis.text.y = element_text(size = 14),
#         plot.title = element_text(size = 28, hjust = 0.5))

#Ahora, qu� tal es el nivel de asociaci�n entre estas 
#dos variables?
ggplot(data = datos_2, aes( x = desempleo, y = inflacion)) + geom_point() +
  theme(axis.text.x = element_text(vjust = .5)) + geom_smooth()+
  labs(x = 'desempleo', y = 'Inflacion', title = 'Inflaci�n vs Desempleo\nen Am�rica Latina') +
  facet_wrap(~periodo) + theme_test() +
  theme(axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        plot.title = element_text(size = 26, hjust = 0.5),
        strip.text = element_text(size = 12),
        axis.title=element_text(size=12,face="bold"))

summary(datos_2)
var(datos_2[!is.na(datos_2$inflacion),c('inflacion','gasto_publico','desempleo','masa_monetaria', 'Tasa_interes')])

cor(datos_2[!is.na(datos_2$inflacion),c('inflacion','gasto_publico','desempleo','masa_monetaria', 'Tasa_interes')])

datos_2 <- datos_2[!is.na(datos_2$inflacion),]
summary(datos_2)
#summary(datos)


#Modelo de Datos de Panel (Efectos Fijos y Aleatorios)
library("plm") # Se llama la librer�a
df_ivsu<-pdata.frame(datos_2, index = c("pais", "periodo"))
head(df_ivsu)
################################################################ hasta aca
#coplot para visualizar los datos
coplot(inflacion ~ periodo|pais, type="b", data=df_ivsu, rows = 1)

# FUNCION A ESTIMAR
# inflacionit=??0+??1desempleoit+??2gasto_publicoit+??it

#Las expresiones para estimar los modelos son:
m.fe <- plm(inflacion ~ desempleo + gasto_publico+ masa_monetaria + Tasa_interes, data = df_ivsu, model = "within") # Efectos Fijos
m.re <- plm(inflacion ~ desempleo + gasto_publico+masa_monetaria + Tasa_interes, data = df_ivsu, model = "random") # Efectos Aleatorios

summary(m.fe)
summary(m.re)

# Veamos los cambios observados por cada pa�s 
# (aporte a la inflacion) en el modelo de efectos fijos:
summary(fixef(m.fe))

# Y el comportamiento global del factor tiempo:
m.twfe <- plm(inflacion ~ desempleo + gasto_publico+masa_monetaria + Tasa_interes, data = df_ivsu, model = "within", effect = "twoways")
data.frame(fixefect = fixef(m.twfe, effect = "time"))

#visto en graficas:
#plot(fixef(m.twfe, effect = "time"), type="l")
fxef<-data.frame(valores.inflacion=fixef(m.twfe, effect = "time"),
                 Periodo=names(fixef(m.twfe, effect = "time")))
ggplot(data = fxef, aes( x = Periodo, y = valores.inflacion, group = 1)) +
  geom_line(size = 0.75) + labs(x = '', y = '') +
  geom_point(size = 3) + geom_smooth(se = F) + geom_smooth(method = 'lm', color = 'red', se = F) +
  theme(axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 26, hjust = 0.5),
        strip.text = element_text(size = 12),
        axis.title=element_text(size=14,face="bold"))
#cuando alla aparece minuscula, yo la pongo mayus
# Ahora, veamos cu�l modelo es preferible
#test de Hausman,estimar el modelo con efectos fijos o con modelos aleatorios.
# En este test se asume que el modelo de efectos fijos 
# es consistente para los par�metros verdaderos, y el modelo
# de efectos aleatorios es una especificaci�n eficiente de 
# los efectos individuales bajo el supuesto de que son 
# aleatorios y siguen una distribuci�n normal.
# Se supone que el modelo de efectos fijos calcula siempre 
# el estimador consistente, mientras que el modelo de efectos 
# aleatorios calcular� el estimador que es consistente y 
# eficiente bajo  H0


phtest(m.re, m.fe)
# El test de Hausman nos indica que el modelo de efectos 
# aleatorios es incosistente, por lo que deber�amos quedarnos 
# con el modelo de efectos fijos.

#pruebas para la estabilidad del modelo
# para los efectos individuales y/o los no observados en 
# el tiempo y de correlaci�n entre los efectos no observados
# y los regresores

# 5. Otro Aspectos sobre Datos de Panel
# # Algo muy com�n es la confusi�n existente entre modelos 
# generalizados mixtos y los modelos 
# # para datos de panel debido a la existencia de efectos fijos 
# y efectos aleatorios en ambos casos, 
# # aunque los GLMM pueden ser empleados tambi�n para analizar 
# datos longitudinales.

# La apropiada estimaci�n del modelo depender� de las propiedades 
# de los t�rminos del error. Estimamos los modelos de efectos fijos 
# y efectos aleatorios para un conjunto de datos. Sin embargo, 
# recordemos que existe varios tipos de datos y, en ocasiones, se 
# require dar un tratamiento especial antes de proceder a estimar 
# el modelo. Veamos algunos ejemplos.
# Vamos a necesitar algunas librer�as que cargaremos en su momento, 
# pero vamos a preparar las l�neas para su instalaci�n por si se requiere:
  




#�form?
form<-inflacion ~ desempleo + gasto_publico+ masa_monetaria + Tasa_interes
formnex<-inflacion ~ desempleo + log(gasto_publico) + masa_monetaria + Tasa_interes

library(dplyr)
library(ggplot2)
library(plm)
library(lmtest)
ls()



#Modelo para las variaciones a nivel de grupo
#Un requisito es la periodizaci�n homog�nea, es decir que no se mezclen unidades temporales.
#Es bastante com�n tener m�s individuos que periodos de observaci�n, adem�s de ser muy com�n 
#la presencia de un panel desbalanceado.
# Nuestro inter�s se centra en dos tipos de efectos: 
#   efectos sobre  Y  que var�an en  t  pero no en  i  
# y efectos que var�an en  i  pero no en  t . 
# Los efectos que var�an en  i  y en  t  se consideran en el t�rmino 
# de error  ??it . Si ignoramos estos efectos, obtendremos 
# coeficientes sesgados. Algo que se puede detectar f�cilmente 
# mediante una inspecci�n gr�fica
#Primero, ignoramos la existencia de los individuos (pa�ses) y se trata cada observaci�n 
#como independiente:
  
# library(plm) # Para usar las funciones
ls()
p.ml <- lm(inflacion ~ desempleo + gasto_publico + masa_monetaria + Tasa_interes, data = df_ivsu)
summary(p.ml)
## le agregamos un intercepto para cada individuo
p.ml2 <- lm(inflacion ~ desempleo + gasto_publico + masa_monetaria + Tasa_interes + pais, data = df_ivsu)
summary(p.ml2)
summary(aov(p.ml2))
## veamos gr�ficamente su sesgo
######################################################################################
library(dplyr) # Para extraer los valores ajustados
invsun <- df_ivsu %>%
  mutate(hat_fe = fitted(p.ml2))
head(invsun)
##############################################################################
library(repr)
options(repr.plot.width=12, repr.plot.height=6)
library(ggplot2)

ggplot(data = data.frame(invsun), aes(x = desempleo, y = hat_fe, 
                                      label = pais, group = pais)) +
  geom_point() +
  # add pais-specific lines
  geom_smooth(method = "lm", se = F, color = "red") +
  # add pooled line
  geom_smooth(mapping = aes(x = desempleo, y = hat_fe), inherit.aes = F,
              method = "lm", se = T, color = "black", linetype = "dashed") +
  # label lines
  geom_text(
    data = data.frame(invsun) %>% 
      group_by(pais) %>% 
      top_n(1, desempleo) %>% 
      slice(1),
    mapping = aes(label = pais), vjust = 1)
###############################################################
# Como se aprecia la pendiente para esta variable regresora cambia dr�sticamente, 
# lo que es signo de coeficientes sesgados (�c�mo ser�a el gr�fico para coeficientes insesgados?). 
# Revisemos c�mo est� el registro de periodos:
ggplot(data = df_ivsu, aes(x = periodo, y = inflacion, group = pais, col = pais)) + 
  geom_line(size = 1) + geom_point(size = 3) + theme_bw()
# # S�lo con inspeccionar la variable de inter�s observamos que 
# tenemos un panel corto (�por qu�?) y desbalanceado donde 
# # los periodos observados no son secuenciales en su extensi�n, 
# adem�s de muchos individuos, por lo que pensar en metodolog�as 
# # de series de tiempo no es procedente. Veamos qu� alternativas 
# tenemos:


#############################################################################################
#Usando variables instrumentales
# Una variable instrumental es aquella que nos permite realizar 
# una estimaci�n consistente cuando las covariables est�n 
# correlacionadas con el error de la regresi�n. Para ilustrarlo, 
# vamos a usar, nuevamente, los conjuntos de datos de la sesi�n 
# anterior:
head(df_ivsu)
# Con el conjunto de datos llamado df_ivsu vamos a 
# construir una variable instrumental para la ecuaci�n 
# de la inflacion. Usaremos la variable ppa_ia rezagada 
# un periodo como variable instrumental. Veamos las 
# formas de introducirla en el algoritmo. Primero, 
# recordemos los modelos antes estimados pero introduzcamos 
# la variaci�n log(ppa_ia) para resolver el problema de 
# escala en los coeficientes:

form <- inflacion ~ desempleo+log(gasto_publico)+masa_monetaria+Tasa_interes ## Simplificar� la escritura en muchos casos
m.fe <- plm(form, data = df_ivsu, model = "within") # Efectos Fijos
m.re <- plm(form, data = df_ivsu, model = "random") # Efectos Aleatorios
summary(m.fe)
summary(m.re)

# La pregunta a resolver es �Efectos Fijo o Efectos Aleatorios?.
# Aunque como vimos el test de Hausman no permite resolverlo,
# esta elecci�n es pr�ctica si el modelo no muestra efectos 
# adicionales. Veamos:
# El estimador de Efectos Fijos permite estimar el modelo bajo 
# supuestos menos restrictivos
# Permite correlaci�n entre los regresores y los efectos individuales
# Permite estimar el modelo incluso si los regresores son 
# "end�genos" PERO es menos deseable en otras dimensiones
# Es menos eficiente
# No identifica los coeficientes de regresores que no var�en en 
# el tiempo. El estimador de Efectos Aleatorios es m�s eficiente
# Si se cumplen supuestos adicionales a los de Efectos Fijos
# PERO puede ser inconsistente. Con esto, introducimos ahora 
# la variable instrumental. Primero para el modelo de efectos fijos:

mod.v.inst.11 <- plm(inflacion ~ desempleo + log(gasto_publico)+masa_monetaria+Tasa_interes | 
                       lag(log(gasto_publico), 1)  + desempleo+masa_monetaria+Tasa_interes+ log(gasto_publico), data = df_ivsu, model = "within")

# Comparemos los coeficientes de este modelo con el mismo sin 
# variables instrumentales
summary(mod.v.inst.11)$coef
summary(m.fe)$coef

# Ahora para los efectos aleatorios
mod.v.inst.1 <- plm(inflacion ~ desempleo + log(gasto_publico)+masa_monetaria+Tasa_interes | 
                      lag(log(gasto_publico), 1)  + desempleo+ masa_monetaria +Tasa_interes+ log(gasto_publico), data = df_ivsu, model = "random")
summary(mod.v.inst.1)$coef
summary(m.re)$coef
# Un buen estimador para el uso de variables instrumentales es el 
# estimador de Hausmann-Taylor que usa variables instrumentales en 
# un modelo de efectos aleatorios; asume cuatro categor�as de 
# regresores: ex�gena variable en el tiempo, end�gena variable en 
# el tiempo, ex�gena invariante en el tiempo y end�gena invariante 
# en el tiempo. Para su estimaci�n, se puede incluir la expresi�n
# "ht" dentro del argumento random.method de la expresi�n:
  
# # Recordemos configurar los datos, pdata.frame puede ser usado en 
# lugar de plm.data. Simplificamos usando el objeto "form" que ya 
# creamos y que contiene la ecuaci�n base del modelo
form <- inflacion ~ desempleo + log(gasto_publico)+masa_monetaria+Tasa_interes
ht <- plm(form, data = df_ivsu, model ="random", random.method = "ht", inst.method = "baltagi")
summary(ht)
summary(m.re)

# Dicho sea de paso, usar variables instrumentales se soluciona 
# la posible endogeneidad

#Modelo de Coeficientes Variables
# Seg�n el tipo de modelo (efectos fijos o efectos aleatorios) 
# es posible estimar un conjunto especial de par�metros donde, 
# si se trata de un modelo de efectos fijos, se obtiene un modelo 
# diferente para cada individuo o periodo de tiempo (seg�n se fije 
# este par�metro) o, si es un modelo de efectos aleatorios, se 
# estima un modelo que emplea los resultados de un modelo previo.


# # Modelo de Coeficientes variables (lo limita el n�mero de 
# variables y n�mero de observaciones)
# # simplificamos la expresi�n
mat.varw <- pvcm(form, data = df_ivsu, model = "within") # fijos
summary(mat.varw)
mat.varr <- pvcm(form, data = df_ivsu, model = "random") # aleatorios
summary(mat.varr)
summary(mat.varw)$coeff
summary(mat.varr)$coeff
summary(m.re)$coef
summary(m.fe)$coef

# 6. Pruebas para Modelos de Datos de Panel 
# (Usando R)

# Los test usados para los modelos de datos de 
# panel involucran, principalmente, pruebas para 
# la estabilidad del modelo, para los efectos 
# individuales y/o los no observados en el tiempo 
# y de correlaci�n entre los efectos no observados
# y los regresores. En esta sessi�n, veremos 
# algunos de los m�s comunes.

#Test de Estabilidad del Modelo
# prueba  F  basada en la comparaci�n de un modelo obtenido 
# para la muestra completa y un modelo basado en la estimaci�n 
# de una ecuaci�n para cada individuo.
# Si debemos llamar la librer�a, recordemos:
library("plm")
# Hemos creado un objeto llamado form con el cual 
# simplificaremos la f�rmula. Vamos a estimar el modelo 
# de coeficientes variables (con la funci�n pvcm) y un 
# modelo de efectos fijos (en la funci�n plm cuando no 
# se especifica, el modelo usado por defecto es el de 
# efectos fijos within):

znp = pvcm(form, data = df_ivsu, model = "within")
zplm = plm(form, data = df_ivsu)

# Y los coeficientes de los modelos:

summary(znp)$coef
summary(zplm)$coef

# La funci�n pooltest permite determinar si los coeficientes 
# de los modelos son iguales. Si no hubiere ninguna 
# diferencia en estimar un modelo u otro los resultados 
# del test apuntar�an a NO RECHAZAR LA HIP�TESIS NULA DE 
# ESTABILIDAD, es decir, vendr�a mejor estimar un modelo 
# de regresi�n para cada individuo.


pooltest(zplm, znp)

# Otra alternativa es introducir la f�rmula en el primer 
# argumento de la funci�n:


pooltest(form, data = df_ivsu, model = "within")
# unstability:inestabilidad
##############################################################
# Seg�n nos sugiere la evidencia, los coeficientes de los 
# modelos no son iguales. Es decir, el modelo de efectos 
# fijos es preferible al modelo de coeficientes variables
##############################################################



#Test para efectos individuales y temporales
# Este tipo de pruebas involucran Multiplicadores de Lagrange. 
# La funci�n plmtest permite implementar varios tipos de test 
# en el argumente type:
#   
#   bp: Breusch and Pagan (1980),
# honda: Honda (1985), the default value,
# kw: King and Wu (1997),
# ghm: Gourieroux, Holly, and Monfort (1982).
# Los efectos probados son indicados con el argumento effect: 
# individual, time o twoways. Usemos el ejemplo que venimos 
# evaluando para ilustrarlo. Vamos a usar un modelo de 
# coeficientes constantes (pooling), es decir, los coeficientes 
# no cambian respecto al tiempo ni entre individuos:

g <- plm(form, data = df_ivsu, model = "pooling")
summary(g)$coef
# la funci�n plmtest utiliza un test de Multiplicador de Lagrange. 
# Por lo general, se eval�a el efecto de dos v�as 
# (individuales y temporales), de no resultar significativo, 
# se procede a evaluar los efectos por separado:

plmtest(g, effect = "twoways", type = "bp")
plmtest(form, data = df_ivsu, effect = "individual", type = "bp")
plmtest(form, data = df_ivsu, effect = "time", type = "bp")

# Los resultados sugieren efectos en dos v�as. 
# Lo que implicar�a la selecci�n de otros tipo de modelo 
# que no considere los efectos por separado.

# De otro lado, la funci�n pFtest calcula una prueba  F 
# basada en la comparaci�n de los modelos within y pooling, 
# lo que dar�a muestras del tipo de modelo que mejor permite 
# explicar el fen�meno:


gwt <- plm(form, data = df_ivsu, effect = "twoways", model = "within")
gp <- plm(form, data = df_ivsu, model = "pooling")
pFtest(gwt, gp)
pFtest(form, data = df_ivsu, effect = "twoways")

##########################################################
# La evidencia apunta a que la mejor opci�n es considerar 
# los efectos tanto individuales como temporales.
##########################################################

# Test de Hausman
# La funci�n phtest permite realizar esta prueba. 
# Se trata de una comparaci�n b�sica que consiste en probar 
# los modelos de efectos fijos y efectos aleatorios donde se 
# determina la consistencia de los modelos. En caso de NO 
# rechazar la hip�tesis de consistencia se debe seleccionar 
# el modelo que se considere consistente (recordemos que en 
# datos de panel el modelo de efectos fijos representa la 
# estructura consistente y el de efectos aleatorios la 
# estuctura eficiente):
# H0:Ambos modelos son consistentes 
# (seleccionar efectos aleatorios)H1:Un modelo es inconsistente 
# (seleccionar efectos fijos)
gw <- plm(form, data = df_ivsu, model = "within")
gr <- plm(form, data = df_ivsu, model = "random")
phtest(gw, gr)
# El test de Hausman sugiere la presencia de un modelo 
# inconsistente. Es decir, podr�amos retomar la idea de 
# evaluar s�lo el modelo de efectos fijos. Sin embargo, 
# recordemos que tenemos evidencia de la presencia tanto 
# de efectos individuales como de efectos temporales.

summary(gw)$coef

################################################
# NO AGREGAR
# Test de Correlaci�n Serial
form
pwtest(form, data = df_ivsu)
###############################################
#Pruebas localmente robustas para la correlaci�n 
#serial o efectos aleatorios

#La presencia de efectos aleatorios puede afectar las 
#pruebas de correlaci�n serial residual, y al contrario. 
#Una soluci�n es usar una prueba conjunta, que tiene poder 
#contra ambas alternativas provista mediante la funci�n pbsytest
pbsytest(form, data = df_ivsu, test = "J") # Es una prueba J de Davidson MacKinnon

# Esta prueba es m�s concluyente por lo que se puede decir que 
# hay evidencia de correlaci�n serial. Aunque, como ya vimos, son 
# p�neles cortos y desbalanceados, por lo que la correlaci�n 
# serial deber� ser tratada de modo especial
#######################################################
#ERRORES IDIOSINCRATIVOS O EFECTOS ALEATORIOS OJO


# Test "por Defecto" para la Correlaci�n Serial
# Es posible implementar un test que permita proceder con cualquier
# tipo de modelo. La funci�n pbgtest provee los elementos para 
# esto y permite determinar si la correlaci�n observada est� 
# asociada a los errores idiosincr�ticos o si procede de los 
# efectos aleatorios. Sigamos con el ejemplo que venimos trabajando:

s.fe <- plm(form, data = df_ivsu, model = "within")
pbgtest(s.fe, order = 2)

# Los resultados sugieren (y siguen apoyando las pruebas 
# anteriores) que la correlaci�n observada es fruto de los 
# efectos idiosincr�ticos. Esto sugiere la necesidad de introducir
# una estructura autorregresiva para modelar la correlaci�n serial.
# Aunque existen alternativas m�s consistentes.

# Estimaci�n Robusta (Matriz de Covarianza)
library(lmtest)
re <- plm(form, data = df_ivsu, model = "random")
summary(re)$coef
coeftest(re, vcov = vcovHC)

# Si con las opciones por defecto est� bien, entonces, tenemos 
# un modelo donde hemos estimado par�metros consistentes con la 
# heterocedasticidad (es decir, de haber heterocedasticidad da 
# lo mismo corregirla que no corregirla). 
# De lo contrario, podemos revisar los argumentos en detalle para 
# cambiar las opciones (usando la funci�n help).
# Hab�amos encontrado la existencia de correlaci�n serial. 
# Podemos intentar detectar el proceso autorregresivo o emplear 
# un modelo que incluya tanto efectos fijos como efectos aleatorios. 
# Caso que abordarmos en la siguiente sesion.
# Finalmente, veamos los valores ajustados de cada modelo, 
# cabe aclarar que existen modelos cuyo ajuste no es compatible 
# con esta estructura de datos

data.frame(df_ivsu,fitted(m.re), fitted(m.fe), fitted(gwt), fitted(znp))
# OJO CON ESTE EL PROBLEMA ES 

# 7. Modelo de Efectos Mixtos �una alternativa para datos de panel?
#   Modelos Mixtos Generalizados Usando R

form <- inflacion ~ desempleo + log(gasto_publico)+masa_monetaria+Tasa_interes

m <- plm(form, data=df_ivsu, effect="twoways", model="within")

fxef<-data.frame(Valores=fixef(m, effect = "time"),
                 periodo=names(fixef(m, effect = "time")))

options(repr.plot.width=8, repr.plot.height=8)

ggplot(data = fxef, aes( x = periodo, y = Valores, group = 1)) + geom_line(size = 0.75) + geom_point() + theme_test() +
  geom_smooth() + theme(axis.title.x = element_text(size = 16),
                        axis.text.x = element_text(size = 16, angle = 90),
                        axis.title.y = element_text(size = 16),
                        axis.text.y = element_text(size = 16),
                        strip.text = element_text(size = 16),
                        legend.position = 'none')

# Primero, comparemos el modelo de efectos aleatorios:
  
  form <- inflacion ~ desempleo + log(gasto_publico)+masa_monetaria+Tasa_interes # Simplificamos la escritura
library('plm') # Llamamos la librer�a para correr el modelo como lo hemos venido haciendo
# Para el modelo mixtos existen dos librer�as �tiles que nos permiten construir el modelo:
library('lme4') # Para el modelo mixto
library('nlme') # Usa la funci�n lme

head(df_ivsu, 10) # Visualizamos el encabezado de los datos, vamos a ampliar a 10 en n�mero de filas a mostrar

####################################################
# El modelo de efectos aleatorios que hemos venido usando
reGLS <- plm(form, data = df_ivsu, model = "random")
# Modelo de efectos aleatorios, veamos la diferencia en la forma como se escribe
reML <- lme(form, data = df_ivsu, random = ~1 | pais)

# Resumen del modelo por M�nimos Cuadrados Generalizados
summary(reGLS)$coeff

# Resumen del modelo estimado mediante M�xima Verosimilitud
data.frame(Estimate = summary(reML)$coef$fixed)
#summary(reML)$coeff
summary(reML)$coeff$random
#########################################################
# Un ajuste que puede explorarse, debido a que hay factores de 
# dependencia en el tiempo, es una estructura de autocorrelaci�n 
# temporal. Para esto requirimos un ajuste previo para evitar 
# incosistencias matriciales:

df_ivsu$a�o <- as.numeric(as.character(df_ivsu$periodo))

# Y, mediante un modelo generalizado, incluimos la estructura 
# de correlaci�n:
lmAR1ML <- gls(form, data=df_ivsu, correlation=corAR1(0,form=~a�o|pais))

# Y, se puede ajustar un intercepto aleatorio (adicional). 
# Esto permitir� determinar si es necesario o no el ajuste de 
# correlaci�n serial.

reAR1ML <- lme(form, data=df_ivsu,random=~1|pais, correlation=corAR1(0,form=~a�o|pais))

# El resumen num�rico del modelo:
  
summary(reAR1ML)

# Tenemos un coeficiente de correlaci�n serial que hemos calculado 
# (phi). Para obtener la prueba de significancia del coeficiente de 
# correlaci�n serial vamos a hacer una prueba de raz�n de 
# probabilidad.
# Una prueba de raz�n de probabilidad para la correlaci�n serial 
# en los residuos idiosincr�sicos se puede hacer como una prueba 
# de modelos anidados, por anova(), comparando el modelo con los 
# residuos idiosincr�sicos esf�ricos con la alternativa m�s general
# que presenta los residuos AR(1). La prueba toma la forma de una 
# prueba de restricci�n cero en el par�metro autorregresivo.
# Esto se puede hacer en modelos de efectos agrupados o aleatorios 
# por igual. Primero informamos el caso m�s simple.

# Ya estimamos el modelo AR(1) de agrupaci�n anterior. 
# El modelo GLS sin correlaci�n en los residuos es el mismo 
# que OLS, y bien podr�a usarse lm() para el modelo restringido, 
# pero vamos a usar gls() que es m�s 

lmML <- gls(form, data=df_ivsu)
anova(lmML, reAR1ML)

# Los resultados de la prueba sugieren que el modelo con ajuste 
# de correlaci�n serial es un mejor modelo para el caso.
# 
# Podemos comparar el modelo restringido con el modelo mixto, 
# para determinar si es necesario o no el intercepto aleatorio:

anova(lmML, reML)
# Seg�n los resultados, el modelo mixto es mejor que el modelo 
# restringido. Probemos compar�ndolo incluyendo la estructura 
# de correlaci�n serial:
  
anova(reML, reAR1ML)

# Observamos que el modelo con estructura de correlaci�n es mejor 
# que el mixto sin correlaci�n. Finalmente, podemos probar y 
# comparar si es necesario incluir o no el intercepto aleatorio:

anova(lmAR1ML, reAR1ML)

# Los resutlados nos sugieren que no se requiere el intercepto 
# aleatorio, pero s� la estructura de correlaci�n serial, lo que 
# indicar�a que el modelo que mejor explica el fen�meno es el 
# modelo generalizado con estructura de autocorrelaci�n lmAR1ML, 
# que se entiende como el modelo de efectos fijos con estructura 
# de autocorrelaci�n.

summary(reAR1ML)
data.frame(coef=summary(reAR1ML)$coef)
ls()
fm1 <- reAR1ML
library(MCMCglmm)
newdata <- data.frame(gasto_publico = rtnorm(6, mean = mean(df_ivsu$gasto_publico), lower=min(df_ivsu$gasto_publico),
                                      upper=max(df_ivsu$gasto_publico)),
                      desempleo = rtnorm(6, mean = mean(df_ivsu$desempleo), lower=min(df_ivsu$desempleo),
                                     upper=max(df_ivsu$desempleo)),
                      masa_monetaria = rtnorm(6, mean = mean(df_ivsu$masa_monetaria), lower=min(df_ivsu$masa_monetaria),
                                         upper=max(df_ivsu$masa_monetaria)),
                      Tasa_interes = rtnorm(6, mean = mean(df_ivsu$Tasa_interes), lower=min(df_ivsu$Tasa_interes),
                                         upper=max(df_ivsu$Tasa_interes)),
                      pais = c("Bolivia","Brasil","Chile","Colombia","Guatemala","Honduras"))

newdata

data.frame(pais = newdata$pais,predict = predict(fm1, newdata, level = 0:1))

