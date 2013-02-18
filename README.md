owlhack
=======

A perl convenience wrapper for OWL ontologies.

Current status: experimental and highly incomplete.

Currently this module relies on
[OWLTools](http://code.google.com/p/owltools) for I/O. Ontologies are
serialized as JSON (standard yet to be fully specified) using the
owltools command line runner.

Example
-------

   # Create an ontology object from an OWL document
   # note: this converts to .ojs behind-the-scenes
   my $ont = OWL->load("pizza.owl"); 

   # Iterate through all SubClass axioms writing Sub-Super pairs
   foreach my $axiom ($ont->getAxioms('SubClassOf')) {
     print $axiom->getSubClass . "\t" . $axiom->getSuperClass . "\n";
   }

Scripts
-------

See the bin/ directory

Requirements
------------

Currently the goals are to keep this fairly minimal - no Moose

 * JSON
 * OWLTools

See INSTALL.md

Documentation
-------------

It's fairly unlikely there will be detailed documentation for this in
the near future. 



See also
--------

 * OWL::DirectSematics

