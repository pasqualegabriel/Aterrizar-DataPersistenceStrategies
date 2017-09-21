package asientoServicio
import static org.junit.Assert.*
import org.junit.Before
import aereolinea.Asiento
import aereolinea.Tramo
import categorias.Categoria
import org.junit.Test
import categorias.Primera
import categorias.Business
import categorias.Turista

class TestAsiento {
	
	Asiento 	testAsiento
	Tramo		tramoDoc
	Categoria 	categoriaDoc
	
	
	@Before
	def void setUp(){
		tramoDoc   		= new Tramo(10.00)
		categoriaDoc	= new Primera
		testAsiento		= new Asiento(tramoDoc,categoriaDoc)
		
	}
	
	@Test
	def test000TestAsientoPuedeCalcularSuPrecioCuandoSuCategoriaEsDePrimera(){
		assertEquals(14.00,testAsiento.calcularPrecio,00000001)
	}
	
	@Test
	def test001TestAsientoPuedeCalcularSuPrecioCuandoSuCategoriaEsBusiness(){
		testAsiento.categoria = new Business
		assertEquals(12.50,testAsiento.calcularPrecio,00000001)
	}
	@Test
	def test002TestAsientoPuedeCalcularSuPrecioCuandoSuCategoriaEsTurista(){
		testAsiento.categoria = new Turista
		assertEquals(11.00,testAsiento.calcularPrecio,00000001)
	}
	
}