package dao

import java.util.List
import asientoServicio.Compra

interface CompraDAO {
	
	def List<Compra> compras(String userName)
}