package cl.duoc.nutrivifs.boleta.repository;

import cl.duoc.nutrivifs.boleta.model.DetalleBoleta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DetalleBoletaRepository extends JpaRepository<DetalleBoleta, Long> {

    boolean existsByProducto_IdProducto(Long idProducto);
}
