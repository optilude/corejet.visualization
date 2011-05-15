import os
import tempfile
import unittest2 as unittest

from corejet.core import story, scenario, given, when, then

@story(id="ST-1", title="As a developer, I can serialize my tests to XML")
class XMLSerialization(unittest.TestCase):
    
    @given("A working directory")
    def userOnLoginPageAndAccountIsLocked(self):
        self.workingDir = tempfile.mkdtemp()
    
    @then("Clean up")
    def cleanUp(self):
        os.removedirs(self.workingDir)
    
    @scenario("Empty catalog")
    class MinimalOutput:
        
        @given("An empty requirements catalog")
        def create(self):
            from corejet.core.model import RequirementsCatalog
            self.catalog = RequirementsCatalog()
        
        @when("The serialize() method is called")
        def serialize(self):
            self.tree = self.catalog.serialize()
        
        @then("A minimal XML tree is output")
        def checkOutput(self):
            import pdb; pdb.set_trace( )
    
    @scenario("Requirements extract")
    class RequirementsExtract:
        
        pass
    
    @scenario("Test run extract")
    class TestRunExtract:
        
        pass
    
    @scenario("Writing to disk")
    class Writing:
        
        pass

@story(id="ST-2", title="As a developer, I can parse tests from XML")
class XMLParsing(unittest.TestCase):
    
    @given("A working directory")
    def userOnLoginPageAndAccountIsLocked(self):
        self.workingDir = tempfile.mkdtemp()
    
    @then("Clean up")
    def cleanUp(self):
        os.removedirs(self.workingDir)
    
    @scenario("Empty catalog")
    class MinimalInput:
        
        @given("An empty requirements catalog")
        def create(self):
            from corejet.core.model import RequirementsCatalog
            self.catalog = RequirementsCatalog()
        
        @when("The serialize() method is called")
        def serialize(self):
            self.tree = self.catalog.serialize()
        
        @then("A minimal XML tree is output")
        def checkOutput(self):
            import pdb; pdb.set_trace( )
    
    @scenario("Requirements extract")
    class RequirementsExtract:
        
        pass
    
    @scenario("Test run extract")
    class TestRunExtract:
        
        pass
