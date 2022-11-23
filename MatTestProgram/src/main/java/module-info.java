module com.mycompany.mattestprogram {
    requires javafx.controls;
    requires javafx.fxml;

    opens com.mycompany.mattestprogram to javafx.fxml;
    exports com.mycompany.mattestprogram;
}
