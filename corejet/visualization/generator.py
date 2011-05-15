import tempfile
import os
import os.path
import shutil
import pkg_resources
import lxml.etree

def generateReportFromCatalogue(catalogue, directory):
    """Given a RequirementsCatalogue object containing test results,
    generate a report in the given directory
    """
    
    # Copy static files to the output directory
    
    for resource in pkg_resources.resource_listdir('corejet.visualization', 'report-template'):
        path = pkg_resources.resource_filename('corejet.visualization', 
                os.path.join('report-template', resource)
            )
        
        if os.path.isdir(path):
            shutil.copytree(path, os.path.join(directory, os.path.basename(path)))
        else:
            shutil.copy(path, directory)

    # XXX: This doesn't work - the XSLT returns None. Using fragile command
    # line option instead :(
    
    fileno, catalogueFile = tempfile.mkstemp()
    
    try:
        with open(catalogueFile, 'w') as f:
            catalogue.write(f)
    
        os.system("xsltproc -o '%s' '%s' '%s'" % (
                os.path.join(directory, 'corejet-requirements.js'),
                pkg_resources.resource_filename('corejet.visualization',
                        os.path.join('xslt', 'corejet-to-jit.xsl',)
                    ),
                catalogueFile,
            ))
    finally:
        os.unlink(catalogueFile)
    
    # # Load XSLT
    # xslt_tree = None
    # 
    # with pkg_resources.resource_stream('corejet.visualization', os.path.join('xslt', 'corejet-to-jit.xsl')) as stream:
    #     xslt_tree = lxml.etree.parse(stream)
    # 
    # xslt = lxml.etree.XSLT(xslt_tree)
    # 
    # # Create JIT output using XSLT
    # source_tree = catalogue.serialize()
    # target_tree = xslt(source_tree)
    # 
    # with open(os.path.join(directory, 'corejet-requirements.js'), 'w') as output:
    #     target_tree.write(output)
