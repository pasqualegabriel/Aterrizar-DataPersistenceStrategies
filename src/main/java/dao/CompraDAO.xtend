package dao

import asientoServicio.Compra

interface CompraDAO {
	def void save(Compra aPurchase)

	def Compra load(Compra aPurchase)

	def void update(Compra aPurchase)
	
	def void clearAll()
}